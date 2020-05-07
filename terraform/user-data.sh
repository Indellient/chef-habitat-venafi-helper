#!/usr/bin/bash
VCERT_BINARY=vcert_linux
LOG_FILE=/tmp/user-data-$(date +%Y-%m-%d).log
S3_SECRETS_BUCKET=venafi-sdk-secrets
METADATA_SERVER=http://169.254.169.254/latest/meta-data
VCERT_URL=https://github.com/Venafi/vcert/releases/download/v4.1.0/vcert_linux

function append_log {
    timestamp=$(date +%Y-%m-%d:%H-%M-%S)
    log_data=$1
    log_entry="[${timestamp}] ${log_data}"
    echo ${log_entry} >> ${LOG_FILE}
}

# Update repositories
sudo yum search gnuplot 2>&1 /dev/null

# Create a log file if it does not exist
if [[ ! -f ${LOG_FILE} ]]; then
    touch ${LOG_FILE}
    append_log "Log file created!"
else
    append_log "File already exists"
fi

# Download creds file from S3
aws s3 cp s3://${S3_SECRETS_BUCKET}/tpp-sdk-creds.sh /tmp/tpp-sdk-creds.sh
source /tmp/tpp-sdk-creds.sh && sudo rm -rf /tmp/tpp-sdk-creds.sh

# Download the vcert binary tool
# 1. Check if wget command exists
# 2. Download the cert command line tool and install to path
type wget &> /dev/null
if [[ $? -eq 0 ]]; then
    append_log "wget tool exists!"
    append_log "Downloading the vcert binary tool .."
    wget ${VCERT_URL} > /dev/null

    # Make the binary executable and add to PATH
    chmod +x ${VCERT_BINARY}
    sudo mv ${VCERT_BINARY} /usr/local/bin/${VCERT_BINARY}
else
    append_log "wget tool not found.. installing!!"
    sudo yum install -y wget.x86_64
fi

# Install apache and mod_ssl
sudo yum install -y httpd mod_ssl

# Get instance public DNS from metadata servers
export INSTANCE_PUBLIC_DNS=$(curl ${METADATA_SERVER}/public-hostname)

# Generate SSL cert for this hostname
append_log "Generating certificate.."
cd /home/ec2-user
${VCERT_BINARY} enroll -tpp-url ${TPP_URL} \
    -tpp-user ${TPP_USER} \
    -tpp-password ${TPP_PASSWORD} \
    -z Certificates\\IndellientTest\\apache \
    -cn ${INSTANCE_PUBLIC_DNS} \
    -key-file apache.key \
    -cert-file apache.crt \
    -chain-file apache-chain.pem \
    -no-prompt

append_log "Moving cert files to respective locations ..."
# Move cert files to proper paths
sudo mv apache.key /etc/pki/tls/private/localhost.key
sudo mv apache.crt /etc/pki/tls/certs/localhost.crt
sudo mv apache-chain.pem /etc/pki/tls/certs/server-chain.crt

append_log "Starting apache .."
# Start apache
sudo systemctl start httpd.service
sudo systemctl enable httpd.service

append_log "Apache started.."

# Upload log files to s3
aws s3 cp ${LOG_FILE} s3://venafi-sdk-secrets/${LOG_FILE}

# Cleanup
sudo rm -rf /tmp/${LOG_FILE}
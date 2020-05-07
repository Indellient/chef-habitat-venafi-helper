pipeline {
    agent any

    environment {
        HAB_NOCOLORING = true
        HAB_BLDR_URL = 'https://bldr.habitat.sh/'
        HAB_ORIGIN=credentials("hab-pkg-origin")
        HAB_AUTH_TOKEN=credentials("hab-bldr-auth-token")
        HAB_CHANNEL='stable'
    }

    stages {
        stage('Build the base hab pkg') {
            steps {
                sh "hab origin key download ${env.HAB_ORIGIN}"
                sh "hab origin key download -s ${env.HAB_ORIGIN}"
                habitat task: 'build',
                    directory: "./base-package/habitat",
                    origin: "${env.HAB_ORIGIN}",
                    docker: true
            }
        }
        // upload base pkg to bldr
        stage('Upload base pkg to depot') {
            steps {
                withCredentials([string(credentialsId: 'hab-bldr-auth-token', variable: 'HAB_AUTH_TOKEN')]) {
                    habitat task: 'upload',
                        authToken: env.HAB_AUTH_TOKEN,
                        lastBuildFile: "${workspace}/results/last_build.env",
                        bldrUrl: "${env.HAB_BLDR_URL}"
                }
            }
        }
        stage('Promote') {
            steps {
                // Parse the pkg ident as env var
                script {
                    env.HAB_PKG_IDENT = sh (
                        script: "grep 'pkg_ident' ./results/last_build.env | cut -d= -f2",
                        returnStdout: true
                    ).trim()
                }
                // promote pkg to stable
                withCredentials([string(credentialsId: 'hab-bldr-auth-token', variable: 'HAB_AUTH_TOKEN')]) {
                    habitat task: 'promote',
                        channel: "${env.HAB_CHANNEL}",
                        authToken: "${env.HAB_AUTH_TOKEN}",
                        artifact: "${env.HAB_PKG_IDENT}",
                        bldrUrl: "${env.HAB_BLDR_URL}"
                }
            }
        }
    }
}
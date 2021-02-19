# Venafi Helper
Indellient Venafi-Habitat helper package using the venafi/vcert SDK.

## Setting up Venafi Helper Habitat Package

Note that if you're using docker (hab studio), you may need to bind ports 443 and 80 using the following export. 

`export HAB_DOCKER_OPTS="-p 80:80 -p 443:443"`

### Running venafi-helper
venafi-helper can be built and run in a Habitat Studio, to do so, do the following (note that this does require some fimilarity with Habitat): 
1. Enter Habitat Studio while in this directory using `hab studio enter` for Linux, OSX or `hab studio enter -D` for Windows.
2. Run `build`.
3. Call the `hab svc load [origin]/venafi-helper`.

### Configuring venafi-helper
venafi-helper relies on a functional config being in place before load / run. Ensure the configuration is setup as follows:

| Configuration     |  Description                                                                           |
|-------------------|----------------------------------------------------------------------------------------|
| `url`             | The url to your Venafi SDK endpoint (e.g. "https://bla.dev.lab.venafi.com/vedsdk")     |
| `user`            | The username you use to authenticate with the SDK.                                     |
| `password`        | The password you use to authenticate with the SDK.                                     |
| `cn`              | The common name of your certificate (e.g. "bla.example.com").                          |
| `zone`            | The zone of your certificate (e.g. "Certificates\\\\Bla").                             |
| `renew-threshold` | The amount of days away from the expiry date to trigger a renewal request.             |
| `expiry-check`    | The interval for checking how close the day is to the 'renew-threshold' date, in days. |

## VCert 

### Building VCert
VCert is required to make use of venafi-helper. You have two options, one is to use the prebuilt one from bldr.habitat.sh or to build your own, in order to build your own use the following instructions via Terminal, Command Prompt or PowerShell:
1. `hab studio enter` for OSX, Linux or `hab studio enter -D` for Windows from project root directory.
2. `cd vcert`
3. `build`
4. Build of VCert is now complete.

## Demos

### Building a Demo
In order to build a demo you simply need to enter Habitat Studio from the project folder and `cd` into the `demo` directory and then into the demo package of your chosing. From there you run the `build` command. You can then run the package against your origin via the `hab svc load` command listed below.

### Running a Demo
Typically to run this with demos you need to simply configure and run the venafi-helper package. Once running, you will be able to bind venafi-helper to one of the demo packages. You can run the demos by going into the directories and going through Step 1-2. Please note that the venafi-helper package should be running before running a demo package. 

For the third step, load the package you build along with a bind to the venafi-helper package.

`hab svc load [origin]/[demo-package-name] --bind helper:venafi-helper.default`

### Example Demo Run
This example demo run will outline running venafi-helper with a demo file using a stable version of venafi-helper and the venafi-tomcat-demo package. 

#### Preparation 
Before running the demo, create a `user.toml` file wherever you intend to enter hab studio from, this can typically be on the Desktop, or in a folder. In the user.toml, replace the placeholders with the correct info and then save the file. Depending on the environment you will be connecting to, your configuration may be set for TPP:
```
cn = "my_common_name"
zone = "my_zone"
renew-threshold = 14
expiry-check = 1

[tpp]
	[tpp.auth]
	url = "my_url"
	user = "my_username"
	password = "my_password"
	token = "my_token"

	[tpp.device]
	register = "false"
	tls_port = 443
	tls_address = "myapp.example.com"
	app-name = "my_app"
	app-info = "my_app_info"
```

Or cloud:
```
cn = "my_common_name"
zone = "my_zone"
renew-threshold = 14
expiry-check = 1

[cloud.auth]
	apikey = "my_apikey"

```

#### Steps
Open a Terminal, Command Prompt or PowerShell window and then do the following, ensuring you're in the same directory as the user.toml you created in your terminal. Note that the demo package `venafi-tomcat-demo` can be replaced with `venafi-nginx-demo` or `venafi-httpd-demo` for both step 4 and 7.
1. `export HAB_DOCKER_OPTS="-p 80:80 -p 443:443"`
2. `hab studio enter`
3. `hab pkg install indellient/venafi-helper`
4. `hab pkg install indellient/venafi-tomcat-demo`
5. `hab config apply venafi-helper.default $(date +%s) user.toml`
6. `hab svc load indellient/venafi-helper`
7. `hab svc load indellient/venafi-tomcat-demo --bind helper:venafi-helper.default`
8. Visit http://localhost or https://localhost and you will see the demo page up.
                                    

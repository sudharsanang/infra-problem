**Solution to Thoughtworks Infra-problem**

1) This solution is designed to keep the current situtation and future in Mind. 
2) Used AWS as that was a bit easy to test.

**Pre-requisite:**
1) AWS Account
2) Create IAM user and download Access key and Secret key
3) Following needs to be installed on the local system:

	•	AWS CLI
	•	Docker
	•	Kubectl
	•	Helm
	•	Terraform
	•	Terragrunt
	•	Java
	•	Clojure
	•	Leiningen

**To Setup Infrastructure:**
1) Run pre-deploy.sh to set the variables
2) Run deploy.sh, this will setup an infra in AWS

**To deploy application:**
  Run app-deploy.sh , which will build and deploy the application in EKS.
**Note:** Creating docker image and storing it in ECR, using helm for the application deployment. This way in future if you need to migrate your application somewhere you can do it on the fly as the appplication is  KNative.

**Future Ready scenarios:**

1) Infra and code together can be deployed using CICD pipeline. 
2) Intergrate Kubernetes with the runner (if Jenkins --> we can configure clouds under manage Jenkins) with which we can let the runner assign a dynamic pod for building, testing the application, let JIB convert the code and push the docker images to registry and helm will create charts using the helm templates which inturn can be deployed to various environemnts.

4) Webhooks/actions can be configured to auto trigger the pipeline upon the successful merge of the latest changes.
5) Google's JIB can be a good candidate for the future, using which we can replace dockerfiles and docker compose files. All we need to do is to configure project.clj with below. This will help us avoid extra code as JIB takes care of converting the artifacts into docker images along with configuring the entrypoint in order for the artifacts to be choosen.

![image](https://user-images.githubusercontent.com/33951509/173561030-cc05f8f0-7985-4ccd-9dd2-be9f993b3520.png)


Detailed documentation is available in https://cloud.google.com/java/getting-started/jib


:plugins 
:jib-build/build-config {:base-image {:type :registry
                                        :image-name "ecr.io/distroless/java"}
                           :target-image {:type :docker
                                          :image-name "helloworld"}}
																					
:target-image {:type :registry
               :image-name "123456789.dkr.ecr.mordor-east-1.amazonaws.com/helloworld"
               :authorizer {:fn leiningen.aws-ecr-auth/ecr-auth
                            :args {:type :access-key
                                   :access-key-id "AK1231232414"
                                   :secret-access-key "111111111111111"}}}
																	 

**References:**

https://docs.aws.amazon.com/eks/latest/userguide/creating-a-vpc.html - for the cloud formation template 


https://registry.terraform.io/ - for terraform modules

https://www.techtarget.com/searchcloudcomputing/tutorial/How-to-deploy-an-EKS-cluster-using-Terraform

----------------------------------------------------------------------------------------------------------------

# DevOps Assessment

This project contains three services:

* `quotes` which serves a random quote from `quotes/resources/quotes.json`
* `newsfeed` which aggregates several RSS feeds together
* `front-end` which calls the two previous services and displays the results.

## Prerequisites

* Java
* [Leiningen](http://leiningen.org/) (can be installed using `brew install leiningen`)

## Running tests

You can run the tests of all apps by using `make test`

## Building

First you need to ensure that the common libraries are installed: run `make libs` to install them to your local `~/.m2` repository. This will allow you to build the JARs.

To build all the JARs and generate the static tarball, run the `make clean all` command from this directory. The JARs and tarball will appear in the `build/` directory.

### Static assets

`cd` to `front-end/public` and run `./serve.py` (you need Python3 installed). This will serve the assets on port 8000.

## Running

All the apps take environment variables to configure them and expose the URL `/ping` which will just return a 200 response that you can use with e.g. a load balancer to check if the app is running.

### Front-end app

`java -jar front-end.jar`

*Environment variables*:

* `APP_PORT`: The port on which to run the app
* `STATIC_URL`: The URL on which to find the static assets
* `QUOTE_SERVICE_URL`: The URL on which to find the quote service
* `NEWSFEED_SERVICE_URL`: The URL on which to find the newsfeed service
* `NEWSFEED_SERVICE_TOKEN`: The authentication token that allows the app to talk to the newsfeed service. This should be treated as an application secret. The value should be: `T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX`

### Quote service

`java -jar quotes.jar`

*Environment variables*

* `APP_PORT`: The port on which to run the app

### Newsfeed service

`java -jar newsfeed.jar`

*Environment variables*

* `APP_PORT`: The port on which to run the app


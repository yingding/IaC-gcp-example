# IaC-gcp-example
this is an IaC example of deploying resources on GCP with terraform 

## Install google cloud sdk (python cli) on MacOSX
```shell
brew install --cask google-cloud-sdk
```

Reference:
* https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke

## Authenticating GCP project in Terraform
Init the project for gcp cli to use
```shell
gcloud init
```

Create an Application Default Credential (ADC) for terraform to sue
```shell
gcloud auth application-default login
```

(Optional) remove the ADC:
```shell
gcloud auth application-default revoke
```

Reference:
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
* GCP ADC https://cloud.google.com/sdk/gcloud/reference/auth/application-default

## Config CLI
List the active gcp account name:
```shell
gcloud auth list
```

List the active gcp projects with associated gcp account:
```shell
gcloud projects list --filter='lifecycleState:ACTIVE'
```

List the project ID:
```shell
gcloud config list project
```

List the current cli project's active config
```shell
gcloud config configurations list
```

## Create service account
```shell
PROJECT_ID=$(gcloud config list --format 'value(core.project)')
```

```shell
SERVICE_ACCOUNT_NAME=<sa-name>
echo ${SERVICE_ACCOUNT_NAME}
gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME} \
  --description="service account to access gcp project from remote terraform" \
  --display-name=${SERVICE_ACCOUNT_NAME}
```

```shell
ROLE=roles/aiplatform.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role=${ROLE}
```
* https://cloud.google.com/vertex-ai/docs/general/access-control
* https://cloud.google.com/iam/docs/service-accounts-create#gcloud

```shell
ROLE=roles/editor
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role=${ROLE}
```

```shell
ROLE=roles/storage.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role=${ROLE}
```

Create a service account key file and save it to your remote workstation
```shell
makedir -p ~/.gcp/
KEY_FILE=~/.gcp/sa-private-key.json
gcloud iam service-accounts keys create ${KEY_FILE} \
--iam-account=${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```
Notice:
* You are using user authentication at this point
* after the service-acccounts key generation, you can remove the user authentication.

Adding the env variable in your shell
```shell
# google credentials
# location of the service account key file
export GOOGLE_CREDENTIALS="~/.gcp/sa-private-key.json"
```

* https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication-configuration

## init terraform
```shell
# init terraform state
terraform init
# plan the change shall be made to your cloud resources
terraform plan
# executed planed changes defined by HCL 
terraform apply
```

(Optional) upgrade the provider version
```shell
terraform init --upgrade
```

## Apply terraform
terraform will take the variables from either `terraform.tfvars` or `.auto.tfvars`

Otherwise, we need to define the .tfvars file during the terraform apply.
```shell
terraform apply -var-file="const.tfvars"
```

## Visualize your terraform plan
```shell
terraform graph -type=plan | dot -Tpng -o graph.png
```

## Learning Source
* Get started with Azure: https://developer.hashicorp.com/terraform/tutorials/azure-get-started
* Get started with GCP: https://developer.hashicorp.com/terraform/tutorials/gcp-get-started
* Visualize your terraform plan: https://medium.com/vmacwrites/tools-to-visualize-your-terraform-plan-d421c6255f9f

## Resources
* https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build
* Authentication GCP - https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
* gcp template module - https://github.com/terraform-google-modules/terraform-google-project-factory
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/version_5_upgrade
* https://stackoverflow.com/questions/57453468/google-cloud-credentials-with-terraform

## GCP pricing
* Region picker - https://googlecloudplatform.github.io/region-picker/



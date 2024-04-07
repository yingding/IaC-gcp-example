variable "gcp_project_id" {
    description = "The gcp project id"
    type        = string
}

variable "gcp_region" {
    description = "The region used to spawn the resources"
    type        = string
}

variable "gcp_zone" {
    description = "The zone used to spawn the resources"
    type        = string
}

terraform {
  required_providers {
    google = {
      version = "~> 5.0.0"
    }
  }
}

# Configure the google provider
provider "google" {
  project     =  var.gcp_project_id
  region      =  var.gcp_region
  zone        =  var.gcp_zone
}





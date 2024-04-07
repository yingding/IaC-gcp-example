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

# tags
variable "label_owner" {
    description = "The owner of the resources"
    type        = string
}

variable "label_zone" {
    description = "The deployment landing zone of the resources"
    type        = string
}

variable "label_app" {
    description = "The deployment application purpose of the resources"
    type        = string
}

terraform {
  required_providers {
    google = {
      # google_workbench_instance uses new features in the google provider
      # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/workbench_instance
      version = "~> 5.23.0"
    }
  }
}

# Configure the google provider
provider "google" {
  project     =  var.gcp_project_id
  region      =  var.gcp_region
  zone        =  var.gcp_zone
}

# Activate services in the gcp project

# Enable API Service on GCP for using gemini api
resource "google_project_service" "vertex_ai_api" {
  project = var.gcp_project_id
  service = "aiplatform.googleapis.com"

  timeouts {
    create = "40m"
    update = "50m"
  }

  disable_dependent_services = true
}

# notebook api
resource "google_project_service" "notebooks_api" {
  project = var.gcp_project_id
  service = "notebooks.googleapis.com"

  timeouts {
    create = "40m"
    update = "50m"
  }

  disable_dependent_services = true
}

# AssetInventory API
resource "google_project_service" "cloudasset_api" {
  project = var.gcp_project_id
  service = "cloudasset.googleapis.com" # free of charge

  timeouts {
    create = "40m"
    update = "50m"
  }

  disable_dependent_services = true
}


# create a notebook instance
# resource "google_workbench_instance" "notebook_instance_1" {
#   name = "gemini-demo-notebook-1"
#   location = var.gcp_zone

#   gce_setup {
#     machine_type = "e2-standard-2" # 2 vCPUs, 8 GB memory $0.1.02 hourly
#     # machine_type = "e2-standard-4" # 4 vCPUs, 16 GB memory $0.182 hourly

#     shielded_instance_config {
#       enable_secure_boot = false
#       enable_vtpm = false
#       enable_integrity_monitoring = false
#     }

#     metadata = {
#       terraform = "true"
#     }

#   }

#   labels = {
#     owner = var.label_owner
#     zone = var.label_zone
#     app = var.label_app
#   }

#   desired_state = "STOPPED"
# }





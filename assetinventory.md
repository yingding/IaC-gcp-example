# Cloud Asset Inventory

## Check available resources on GCP

show all Assets with label `owner=${RESOURCE_LABEL_OWNER_VALUE}`
```shell
PROJECT_ID=$(gcloud config list --format 'value(core.project)')
RESOURCE_LABEL_OWNER_VALUE=yingding
gcloud asset search-all-resources \
--scope="projects/${PROJECT_ID}" \
--query="labels.owner=${RESOURCE_LABEL_OWNER_VALUE}" \
--order-by="assetType DESC, name" \
--read-mask="name,assetType,location"
```

show all available Assets 
```shell
PROJECT_ID=$(gcloud config list --format 'value(core.project)')
RESOURCE_LABEL_OWNER_VALUE=yingding
gcloud asset search-all-resources \
--scope="projects/${PROJECT_ID}" \
--order-by="assetType DESC, name" \
--read-mask="name,assetType,location"
```

* https://cloud.google.com/asset-inventory/docs/export-asset-metadata
include "root" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../../terraform/modules/s3"
}

inputs = {
  bucket_name = "prod-floci-lab-media"
  enable_versioning = true
}

module "iam" {
  source             = "./modules/iam"
  project_id         = var.project_id
  service_account_id = var.service_account_id
}

module "cloud_run" {
  source                = "./modules/cloud_run"
  project_id            = var.project_id
  region                = var.region
  image_url             = var.image_url
  service_name          = var.mcp_service_name
  service_account_email = module.iam.service_account_email
}

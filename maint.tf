data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "s3_mlops"{
  source = "./s3"
  s3_bucket_input_training_path = local.s3_bucket_input_training_path
  s3_object_training_data = local.s3_object_training_data
  s3_bucket_output_models_path = local.s3_bucket_output_models_path
  
}

module "sagemaker_mlops"{
  source = "./sagemaker"
  region = var.region
  project_name = var.project_name
  training_instance_type = var.training_instance_type
  inference_instance_type = var.inference_instance_type
  volume_size_sagemaker = var.volume_size_sagemaker
  handler_path = var.handler_path
  handler = var.handler
  notebook_volume_size = var.notebook_volume_size
  notebook_name = var.notebook_name
  notebook_instance_type = var.notebook_instance_type
  bucket_training_data_arn = module.s3_mlops.bucket_training_data_arn
  bucket_output_models_arn = module.s3_mlops.bucket_output_models_arn
  vpc_id = var.TF_VAR_vpc_id
  subnets_ids = var.TF_VAR_subnet_id
  security_group_id = var.TF_VAR_security_group_id
  current_id = var.TF_VAR_account_id
  user_profile_names = var.user_profile_names
}

module "ecr_mlops"{
  source = "./ecr"
  project_name = var.project_name

}

module "lambda_mlops"{
  source = "./lambda"
  project_name = var.project_name
  lambda_function_name = local.lambda_function_name
  handler_path = var.handler_path
  handler = var.handler
  lambda_folder = local.lambda_folder
  lambda_zip_filename = local.lambda_zip_filename
  role_sf_exec_name=module.stepFunctions_mlops.role_sf_exec_name
  current_id = var.TF_VAR_account_id
}

module "stepFunctions_mlops"{
  source = "./stepFunctions"
  project_name = var.project_name
  training_instance_type = var.training_instance_type
  inference_instance_type = var.inference_instance_type
  volume_size_sagemaker = var.volume_size_sagemaker
  lambda_function_arn=module.lambda_mlops.lambda_function_arn
  ecr_repository_url=module.ecr_mlops.repository_url
  bucket_output_models_bucket=module.s3_mlops.bucket_output_models_bucket
  sagemaker_exec_role_arn=module.sagemaker_mlops.sagemaker_data_science_exec_role_arn
  bucket_training_data_bucket=module.s3_mlops.bucket_training_data_bucket
  current_id = var.TF_VAR_account_id
}

module "storage_mlops" {
    source      = "./store"
    buckets     = var.buckets_store 
}

module "glue" {
  source = "./glue"
  project_name = var.project_name
  current_id = var.TF_VAR_account_id
}

module "emr_mlops"{
  source = "./emr"

  cluster_count = local.cluster_count
  env = local.env
  master_instance_count = local.master_instance_count
  master_instance_type = local.master_instance_type
  core_instance_count = local.core_instance_count
  core_instance_type = local.core_instance_type
  release_label = local.release_label
  

  #Naming
  function              = local.function
  region_code           = local.region_code
  region                = local.region
  app_name              = local.app_name
  applications          = local.applications

  #Meta
  environment           = local.environment
  workspace             = local.workspace
  account_id            = local.account_id
  environment_number    = var.TF_VAR_environment_number

  ## Tagging
  product               = local.product                      # default: ""       (?)
  cost_center           = local.cost_center                  # default: 1836             
  shared_costs          = local.shared_costs                 # default: "No"          
  apm_functional        = local.apm_functional               # default:         
  cia                   = local.cia                          # default: "CLL"
  custom_tags           = local.custom_tags
  entity                = local.entity

  ## Network
  vpc_id                = local.vpc_id
  subnet_ids            = local.emr_subnet_ids
  route_table_ids       = local.route_table_ids
  default_security_group_id = var.TF_VAR_security_group_id


}

module "emr_mlops"{
  source = "./emr"
  
  cluster_count = local.cluster_count
  env = local.env
  master_instance_count = local.master_instance_count
  master_instance_type = local.master_instance_type
  core_instance_count = local.core_instance_count
  core_instance_type = local.core_instance_type
  release_label = local.release_label


  #Naming
  function              = local.function
  region_code           = local.region_code
  region                = local.region
  app_name              = local.app_name
  applications          = local.applications

  #Meta
  environment           = local.environment
  workspace             = local.workspace
  account_id            = local.account_id
  environment_number    = var.TF_VAR_environment_number

  ## Tagging
  product               = local.product                      # default: ""       (?)
  cost_center           = local.cost_center                  # default: 1836             
  shared_costs          = local.shared_costs                 # default: "No"          
  apm_functional        = local.apm_functional               # default:         
  cia                   = local.cia                          # default: "CLL"
  custom_tags           = local.custom_tags
  entity                = local.entity

  ## Network
  vpc_id                = local.vpc_id
  subnet_ids            = local.emr_subnet_ids
  route_table_ids       = local.route_table_ids
  default_security_group_id = var.TF_VAR_security_group_id
}
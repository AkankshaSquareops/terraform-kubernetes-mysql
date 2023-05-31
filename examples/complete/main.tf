locals {
  name        = "mysql"
  region      = "us-east-2"
  environment = "prod"
  additional_tags = {
    Owner      = "organization_name"
    Expires    = "Never"
    Department = "Engineering"
  }
}

module "mysql" {
  source       = "squareops/mysql/kubernetes"
  cluster_name = ""
  mysqldb_config = {
    name                       = local.name
    values_yaml                = file("./helm/values.yaml")
    environment                = local.environment
    architecture               = "replication"
    storage_class_name         = "gp3"
    custom_user_username       = "admin"
    primary_db_volume_size     = "10Gi"
    secondary_db_volume_size   = "10Gi"
    secondary_db_replica_count = 2
  }
  mysqldb_backup_enabled = true
  mysqldb_backup_config = {
    s3_bucket_uri        = "s3://bucket_name"
    s3_bucket_region     = "bucket_region"
    cron_for_full_backup = "* * * * *"
  }
  mysqldb_restore_enabled = true
  mysqldb_restore_config = {
    s3_bucket_uri    = "s3://bucket_region/filename"
    s3_bucket_region = "bucket_region"
  }
  mysqldb_exporter_enabled = true
}

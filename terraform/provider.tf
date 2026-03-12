provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3         = "http://localhost:4570"
    iam        = "http://localhost:4570"
    eks        = "http://localhost:4570"
    ec2        = "http://localhost:4570"
    rds        = "http://localhost:4570"
    elasticache= "http://localhost:4570"
    sts        = "http://localhost:4570"
  }
}


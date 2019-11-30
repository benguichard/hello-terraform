# Configure Terraform
terraform { required_version = ">= 0.12.0" }

# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

################################################
### RESSOURCES
################################################

resource "aws_elastic_beanstalk_application" "eb_application" {
  name        = var.application_name
  description = "Application to try a deployment from Terraform Cloud"
}

resource "aws_elastic_beanstalk_environment" "eb_environment" {
  name                = "default"
  application         = aws_elastic_beanstalk_application.eb_application.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.14.1 running Go 1.13.2"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
}

################################################
### OUTPUTS
################################################

output "eb_endpoint" {
  value       = aws_elastic_beanstalk_environment.eb_environment.endpoint_url
  description = "The URL to the Load Balancer for this Environment"
}

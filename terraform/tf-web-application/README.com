# Web Application

## Registering a Domain

- Register a new domain in route53
- https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html

## Request an SSL Certificate

- Request a certificate
- https://us-east-1.console.aws.amazon.com/acm/home?region=us-east-1#/certificates/list

## Route 53 Hosted Zone

- When you purchase a domain from your account, the hosted zone should already exist

## Groups

- Create a group with role PowerUserAccess
- Add the Automation user and add to the Automation Group

## Resources

- Using tf_var files: https://spacelift.io/blog/terraform-tfvars

## Configuration

- Use separate configuration files to configure the secrets for Terraform
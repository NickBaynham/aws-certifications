# Terraform WordPress in AWS

Add variables to terraform.tfvars and user.tfvars

```
terraform plan -var-file="user.tfvars"
terraform apply -var-file="user.tfvars"
terraform destroy -var-file="user.tfvars"
```


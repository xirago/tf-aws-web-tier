# Infrastructure deployment exercise

This Terraform repository defines a basic set AWS infrastructure resources for a three tier web application environemt.

- Application Load Balancer (port 80)
- EC2 instance(s) in an Auto-Scaling Group
- RDS MySQL DB

## Deployment notes

- Terraform statefile is local only and is not backed up or secure
- Terraform expects user access with suffiecnety permissive IAM role to deply these [resources](#resources)
- EC2 instances use latest Amazon Linux AMI- This is determined at first deployment
- Autoscaling group uses launch template to allow deployment changes to be managed
- RDS MySQL database uses standard username & terrafrom generated random password
- Generated DB password (and DB username) is stored in AWS Secrets Manager
- EC2 instances deployed in the defined AutoScaling Group have IAM access to read these specific secrets
- No log or metric ingestion is defined or configured

### How to deploy

Ensure you have [required version](#requirements) of [Terraform](https://releases.hashicorp.com/terraform/) installed.
Deployment is expected to be short live and non-critical and by default will be destroyed without any recovery. Update terraform variable [`force_destroy`](/variables.tf#L38) to change this behaviour.
If a pre-existing SSH public key has been added to the AWS account it can be added by specifing name in [`ssh_key_name`](/variables.tf#L44). SSH network access to the internal only private subnets is not granted.
In a AWS authenticated terminal session run the commands below to see TF deployment plan:

```bash
terraform init
terrafform plan -out my-deploy.plan
```

Examine the plan output and when ready execute the plan with:

```bash
terraform apply my-deploy.plan
```

Once deloyed, all resources can be desteoyed:

```bash
terraform apply --destroy
```

## Future Improvements

- Functional requirements did not specify any software package requirements for the EC2 instances, and therefore there is no response on port 80 from the deployed instances. Leverage EC2 user-data to provision OS packages and confiuration as needed to build a functional web tier.
- Application load-balancer should have an AWS Certificate Manager TLS certificate and matching long-term Route53 DNS name aliased to the ephemeral ALB DNS.
- Enable reliable & secure storage remote statefile storage (S3 or TFC remote backend).
- Configure cloudwatch, S3 for basic observability
- Consider using AWS provider [`default_tags`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags) for resource tagging.
- Consider creating and using dedicated KMS keys for encrypted resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.6 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.66.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb.frontend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_db_instance.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.access_asm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_secretsmanager_secret.db_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.db_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.db_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.db_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [random_password.database](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_ami.awslinux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.asm_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_username"></a> [database\_username](#input\_database\_username) | A given username for the DB user | `string` | `"root"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Destroy all resources without ANY chance for recovery | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Root name for resources in this project | `string` | `"three-tier-demo"` | no |
| <a name="input_newbits"></a> [newbits](#input\_newbits) | How many bits to extend the VPC cidr block by for each subnet | `number` | `8` | no |
| <a name="input_private_subnet_count"></a> [private\_subnet\_count](#input\_private\_subnet\_count) | How many private subnets to create | `number` | `3` | no |
| <a name="input_public_subnet_count"></a> [public\_subnet\_count](#input\_public\_subnet\_count) | How many subnets to create | `number` | `3` | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | (optional) Add pre-existing SSH key to ASG instances | `string` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC cidr block | `string` | `"10.1.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load-balancer-url"></a> [load-balancer-url](#output\_load-balancer-url) | URL of the deployed load balancer endpoint |
<!-- END_TF_DOCS -->

#  aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-2.0.20210721.2-x86_64-ebs" --query 'sort_by(Images, &CreationDate)[].ImageId' | jq -r
# Define a very basic launch template
resource "aws_launch_template" "default" {
  image_id      = data.aws_ami.awslinux.image_id
  instance_type = "t3.nano"

  tags = local.tags
}

# Deploy minimal ASG across private subnets
resource "aws_autoscaling_group" "cint-demo" {
  vpc_zone_identifier = tolist(aws_subnet.private[*].id)

  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  launch_template {
    id      = aws_launch_template.default.id
    version = aws_launch_template.default.latest_version
  }
}

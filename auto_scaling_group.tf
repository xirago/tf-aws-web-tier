# Define a very basic launch template
resource "aws_launch_template" "default" {
  image_id               = data.aws_ami.awslinux.image_id
  instance_type          = "t3.nano"
  key_name               = var.ssh_key_name
  name_prefix            = var.name
  vpc_security_group_ids = [aws_security_group.private.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.default.arn
  }
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

  # attach asg to alb target group
  target_group_arns = [aws_lb_target_group.asg.arn]
}

# Define a frontend , HTTP listener and target group
resource "aws_alb" "frontend" {
  name            = "${var.name}-alb-80"
  subnets         = tolist(aws_subnet.public[*].id)
  security_groups = [aws_security_group.public.id]
  tags = merge(
    { Name = "${var.name}-alb" },
    local.tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }

  tags = merge(
    { Name = "${var.name}-listener" },
    local.tags
  )
}

# Target group is attached by asg resource
resource "aws_lb_target_group" "asg" {
  name     = var.name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = merge(
    { Name = "${var.name}-target-group" },
    local.tags
  )
}

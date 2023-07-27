resource "aws_security_group" "private" {
  name        = "private_allow_http"
  description = "Allow HTTP from ALB in and all out"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from public ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = tolist(aws_subnet.public[*].cidr_block)
  }

  egress {
    description = "Allow all out to internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "${var.name}-private-http" },
    local.tags
  )
}

resource "aws_security_group" "public" {
  name        = "alb_http_permit"
  description = "Allow HTTP to/from from intenret"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from public subnets"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP to private subnets"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = tolist(aws_subnet.private[*].cidr_block)
  }


  tags = merge(
    { Name = "${var.name}-public-http" },
    local.tags
  )
}

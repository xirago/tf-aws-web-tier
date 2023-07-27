# Create a secret password for DB user
resource "random_password" "database" {
  length  = 16
  special = true
}

# Create DB subnet group across private subnets
resource "aws_db_subnet_group" "database" {
  name       = "${var.name}-dbsg"
  subnet_ids = tolist(aws_subnet.private[*].id)
  tags       = local.tags

}

# Create a basic MySQL DB isntance
resource "aws_db_instance" "database" {
  allocated_storage   = 50
  db_name             = "${local.shortname}db"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  storage_encrypted   = true
  skip_final_snapshot = var.force_destroy == true ? true : false
  multi_az            = true

  username = "root"
  password = random_password.database.result

  tags = merge(
    { Name = "${local.shortname}db" },
    local.tags
  )
}

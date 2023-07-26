# Create AWS Secret Manager secrets for DB user/pass
resource "aws_secretsmanager_secret" "db_user" {
  name        = "db_user"
  description = "Database username"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "db_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = var.database_username
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "db_password"
  description = "Database password"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.database.result
}

# Create AWS Secret Manager secrets for DB user/pass
resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${local.shortname}/db_password"
  description             = "Database password"
  recovery_window_in_days = var.force_destroy == true ? 0 : null
  tags                    = local.tags
}

resource "aws_secretsmanager_secret" "db_user" {
  name                    = "${local.shortname}/db_user"
  description             = "Database username"
  recovery_window_in_days = var.force_destroy == true ? 0 : null
  tags                    = local.tags
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.database.result
}

resource "aws_secretsmanager_secret_version" "db_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = var.database_username
}

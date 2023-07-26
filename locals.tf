locals {
  # Use provided name as prefix
  shortname = replace(var.name, "-", "")

  tags = {
    project = var.name
  }
}

locals {
  # Use provided var.name as prefix on some resources
  shortname = replace(var.name, "-", "")

  tags = {
    project = var.name
  }
}

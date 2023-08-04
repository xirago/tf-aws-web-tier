resource "aws_iam_instance_profile" "default" {
  name = "${var.name}-default-profile"
  path = "/"
  role = aws_iam_role.default.name
}

resource "aws_iam_role" "default" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  name               = "${var.name}-access-role"
  path               = "/"
}

resource "aws_iam_role_policy" "access_asm" {
  name   = "${local.shortname}_policy"
  policy = data.aws_iam_policy_document.asm_access.json
  role   = aws_iam_role.default.id
}

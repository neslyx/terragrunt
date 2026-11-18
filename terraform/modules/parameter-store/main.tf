resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name  = "/${var.environment}/${each.key}"
  type  = "String"
  value = each.value
}
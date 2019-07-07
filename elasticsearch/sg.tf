resource "aws_security_group" "main" {
  name   = "${local.name}-elasticsearch-${var.type}-security-group"
  vpc_id = var.vpc_id

  tags = merge(
    local.tags,
    {
      "Name"        = "${local.name}-elasticsearch-${var.type}"
      "Description" = "SecurityGroup for ${local.name}"
    }
  )
}

# TODO confirm if needed, remove if not
resource "aws_security_group_rule" "elasticsearch_ssh_access" {
  count                    = length(var.security_group_ids)
  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = var.security_group_ids[count.index]
}

resource "aws_security_group_rule" "elasticsearch_https_access" {
  count                    = length(var.security_group_ids)
  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  source_security_group_id = var.security_group_ids[count.index]
}


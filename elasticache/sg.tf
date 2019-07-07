resource "aws_security_group" "main" {
  name   = "${local.name}-elasticache-${var.type}-security-group"
  vpc_id = var.vpc_id

  tags = merge(
    local.tags,
    {
      "Name"        = "${local.name}-elasticache-${var.type}"
      "Description" = "SecurityGroup for ${local.name}"
    }
  )
}

resource "aws_security_group_rule" "redis_access" {
  count                    = length(var.security_group_ids)
  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = var.security_group_ids[count.index]
}


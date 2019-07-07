resource "aws_elasticache_subnet_group" "main" {
  name       = "${local.name}-${var.engine}-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_replication_group" "service" {
  count                         = var.type == "cluster" ? 0 : 1
  automatic_failover_enabled    = var.multi_az
  replication_group_id          = "${local.name}-group"
  replication_group_description = "${local.name} Replication Group"
  engine                        = var.engine
  engine_version                = var.engine_version
  node_type                     = var.instance_type
  parameter_group_name          = local.parameter_group_name
  subnet_group_name             = aws_elasticache_subnet_group.main.name
  security_group_ids            = [aws_security_group.main.id]
  number_cache_clusters         = var.replica_count + 1
  maintenance_window            = var.maintenance_window
  port                          = var.port
  at_rest_encryption_enabled    = "true"
  transit_encryption_enabled    = "true"

  tags = merge(
    local.tags,
    {
      "Name" = "${local.name}-${var.engine}-cluster"
    }
  )
}

resource "aws_elasticache_replication_group" "cluster" {
  count                         = var.type == "cluster" ? 1 : 0
  automatic_failover_enabled    = var.multi_az
  replication_group_id          = "${local.name}-group"
  replication_group_description = "${local.name} Group"
  engine                        = var.engine
  engine_version                = var.engine_version
  node_type                     = var.instance_type
  parameter_group_name          = local.parameter_group_name
  subnet_group_name             = aws_elasticache_subnet_group.main.name
  security_group_ids            = [aws_security_group.main.id]
  maintenance_window            = var.maintenance_window
  port                          = var.port
  at_rest_encryption_enabled    = "true"
  transit_encryption_enabled    = "true"

  cluster_mode {
    replicas_per_node_group = var.replica_count
    num_node_groups         = var.node_count
  }

  tags = merge(
    local.tags,
    {
      "Name" = "${local.name}-${var.engine}-cluster"
    }
  )
}


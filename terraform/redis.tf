resource "aws_elasticache_subnet_group" "voting_redis" {
  name       = "voting-redis-subnets"
  subnet_ids = [aws_subnet.voting_private_a.id, aws_subnet.voting_private_b.id]
}

resource "aws_elasticache_cluster" "voting_redis" {
  cluster_id           = "voting-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.voting_redis.name
}


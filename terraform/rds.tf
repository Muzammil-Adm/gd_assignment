resource "aws_db_subnet_group" "voting_postgres" {
  name       = "voting-postgres-subnets"
  subnet_ids = [aws_subnet.voting_private_a.id, aws_subnet.voting_private_b.id]
}

resource "aws_db_instance" "voting_postgres" {
  identifier             = "voting-postgres"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "voting"
  password               = "SuperSecure123!"
  db_subnet_group_name   = aws_db_subnet_group.voting_postgres.name
  skip_final_snapshot    = true
  backup_retention_period = 0
}


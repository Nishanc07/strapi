resource "aws_db_subnet_group" "nish_db_subnet_group" {
  name       = "nish-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "Strapi DB Subnet Group"
  }
}

resource "aws_db_instance" "nisha_rds" {
  identifier             = "nisha-postgres-db"  
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.22-rds.20240418"
  instance_class         = "db.t3.micro"
  db_name                = "strapidb"
  username               = "nisha"
  password               = "nisha123"
  db_subnet_group_name   = aws_db_subnet_group.nish_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.nisha_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = true

  tags = {
    Name = "Nisha RDS Instance"
  }
}
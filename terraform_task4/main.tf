resource "aws_key_pair" "deployer" {
  key_name   = "strapi-key-nisha"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "strapi_sg" {
  name        = "nisha-strapi-sg"
  description = "Allow HTTP and SSH access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nisha_ec2" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y docker.io
    systemctl start docker
    systemctl enable docker

    usermod -aG docker ubuntu
    mkdir -p /srv/pgdata

    docker network create my-network

    docker run -d --name postgres --network my-network \
        -e POSTGRES_DB=strapi-db \
        -e POSTGRES_USER=nisha \
        -e POSTGRES_PASSWORD=nisha123 \
        -v /srv/pgdata:/var/lib/postgresql/data \
        postgres:15

    sleep 10

    docker pull nishanc7/strapi:latest

    docker run -d --name strapi --network my-network \
        -e DATABASE_CLIENT=postgres \
        -e DATABASE_HOST=postgres \
        -e DATABASE_PORT=5432 \
        -e DATABASE_NAME=strapi-db \
        -e DATABASE_USERNAME=nisha \
        -e DATABASE_PASSWORD=nisha123 \
        -e DATABASE_SSL=false \
        -e APP_KEYS='090TadpTTRZvuM5Fu75COQ==,c8udgtcvVKlGDIMcmqKu+w==,tsHHrNzqiXFBjHNM/79rbA==,/nRmlzj0U/XxgDh8AYzteA==' \
        -e API_TOKEN_SALT='oo7Y59VwBZjdfVsTevVUAQ==' \
        -e ADMIN_JWT_SECRET='V0bNAdPbUmZPcTeVeRSZDw==' \
        -e TRANSFER_TOKEN_SALT='bvqS1Wdms+TMgaZ+brhE9A==' \
        -e ENCRYPTION_KEY='vYbedSqFjzpJgzGquSU8Mw==' \
        -p 1337:1337 \
        nishanc7/strapi:latest
  EOF

  tags = {
    Name = "Nisha_Strapi"
  }
}

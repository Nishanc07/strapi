#!/bin/bash

# Update and install Docker
apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker

usermod -aG docker ubuntu

# Create Docker network
docker network create my-network

# Run PostgreSQL container
docker run -d --name postgres --network my-network \
  -e POSTGRES_DB=strapi-db \
  -e POSTGRES_USER=nisha \
  -e POSTGRES_PASSWORD=nisha123 \
  -v /srv/pgdata:/var/lib/postgresql/data \
  postgres:15

# Pull Strapi image
docker pull nishanc7/strapi-app:latest

# Run Strapi container
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
  nishanc7/strapi-app:latest

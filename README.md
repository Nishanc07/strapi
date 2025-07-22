# 🚀 Getting started with Strapi

TASK 1: Understanding the folder and file structure of strapi
Clone the repo

```
npx create-strapi-app@latest
```

Content-type Builder allows the creation and management of content-types, which can be-

Collection types: content-types that can manage several entries.
Single types: content-types that can only manage one entry.
Components: content structure that can be used in multiple collection types and single types. Although they are technically not proper content-types because they cannot exist independently, components are also created and managed through the Content-type Builder, in the same way as collection and single types.

You can access this data using api

Task 2:
Building Dockerfile (refer the file)
Build and run Dockerfile

```
docker build -t strapi-dev .
docker run -p 1337:1337 strapi-dev
```

after this you can access strapi admin pannel locally at port 1337

TASK 3:
set up a Dockerized Strapi + PostgreSQL + Nginx environment with a user-defined network:

- Create a Docker network

```
docker network create my-network
```

- Create an Nginx config file (e.g., default.conf), where you define how nginx should divert the traffic to. make sure nginx is sending traffic to strai application. Nginx listens on port 80
- in your docker-compose file you are running 3 containers. postgres connected to strapi and nginx as a reverse proxy

To bring the containers up, run

```
docker-compose up -d
```

you can asses it on http://localhost. the traffic will be redirected to strapi

TASK 4: Automating Strapi Deployment on EC2 with Terraform
s1. Build and push the image to a public repo:

```
docker buildx create --use
docker buildx build --platform linux/amd64 -t nishanc7/strapi-app:latest . --push
```

S2. Add terraform files and user data in the section under instance resources

S3. Deploy using terraform (Terraform apply)

You will be able to assess the application on
http://<ec2-public-ip>:1337
make sure it's http not https

TASK 5:
Automate Strapi Deployment with GitHub Actions + Terraform

1. CI/CD - Code Pipeline
   Set up .github/workflows/ci.yml to:
   Run on push to main branch.
   Build Docker image of Strapi.
   Push to Docker Hub
   Save image tag as GitHub Action output.
2. CD - Terraform Pipeline
   Set up .github/workflows/terraform.yml to:
   Be manually triggered (workflow_dispatch)
   Run terraform init, plan, and apply
   Use GitHub Secrets for AWS credentials
   Use output image tag to pull and deploy container on EC2

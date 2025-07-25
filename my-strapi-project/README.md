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

```
you can asses it on http://localhost. the traffic will be redirected to strapi
```

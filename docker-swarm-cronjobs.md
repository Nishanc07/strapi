### Docker Swarm Cronjobs – Documentation

1. What is Docker Swarm?
   -A Docker swarm refers to a collection of physical or virtual machines functioning together as a cluster. When a machin becomes part of this cluster, it assumes the role of a node in the Docker swarm.
   -Cronjobs are scheduled tasks that run periodically at fixed times, dates, or intervals.

In Docker Swarm, running periodic jobs like database backups, log rotation, or container clean-up is not natively supported, unlike Kubernetes' CronJob. To bridge this gap, open-source tools such as swarm-cronjob and various workarounds can be used to schedule containerized jobs at specific times

2. Popular Tools for Swarm Cronjobs
   crazy-max/swarm-cronjob: A Go-based scheduler that continuously scans Docker services labels to trigger tasks according to cron expressions
   ref: https://crazymax.dev/swarm-cronjob/usage/get-started/

   swarm-scheduler: A Ruby-based scheduler that uses standard crontab entries to launch tasks as Docker services defined in a Compose stack
   ref: https://github.com/rayyansys/swarm-scheduler

   webgriffe/swarm-cron: A PHP-based solution to trigger jobs inside your stack by watching schedules.
   ref: https://github.com/webgriffe/swarm-cron

   and many more....

Note: If you prefer a self-managing, label-driven scheduler that integrates seamlessly and doesn’t require external cron files, go with crazy‑max/swarm‑cronjob. It’s widely used and actively maintained.

3. How to deploy this using swarm-cronjob by crazymax
   How it works:
   You add a label to your service saying when it should run
   Example label: "swarm.cronjob.schedule=\* \* \* \* \*" → means run every minute
   The tool automatically reads these labels and runs your job at the right ti

Step 1: Prerequisites
Docker Swarm initialized (docker swarm init)
At least one manager node in your Swarm cluster

Step 2: Deploying swarm-cronjob as a Service
Deploy swarm-cronjob Scheduler First
Create a file called swarm-cronjob.yml

```
version: "3.8"

services:
  swarm-cronjob:
    image: crazymax/swarm-cronjob:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    deploy:
      mode: global
      placement:
        constraints:
          - node.role == manager
```

Run:

```
docker stack deploy -c swarm-cronjob.yml cron
```

Step 3: Create Your First Cron Job
Now we’ll make a service that runs every minute.
createa file hello-cron.yml

```
version: "3.8"

version: "3.8"

services:
  strapi-cron:
    image: strapi/strapi:latest
    command: ["node", "scripts/cleanup.js"]
    deploy:
      labels:
        - "swarm.cronjob.enable=true"
        - "swarm.cronjob.schedule=0 3 * * *"   # every day at 3 AM
        - "swarm.cronjob.skip-running=true"

```

This will spin up a Strapi container, run the script, and exit.

Deploy it:

```
docker stack deploy -c hello-cron.yml cron
```

Verify by

```
docker service logs cron_hello-cron

```

You should see something like -
Hello from Swarm!
Wed Aug 6 11:42:01 UTC 2025

Key Points

- swarm.cronjob.enable=true → tells the scheduler to watch this service
- swarm.cronjob.schedule=\* \* \* \* \* → cron format timing
- The job runs as a short-lived container each time
- Works for any container image (backup scripts, API calls, report generation, etc.)

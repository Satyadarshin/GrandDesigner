# GrandDesigner WordPress Docker Development Environment

This repository contains the Docker configuration for the development environment of the www.satyadarshin.com WordPress site. It mimicks the production server environment, allowing us to have some confidence that if the code works in development, it should also work in production. 

To set up the Docker development environment, follow the setup instructions below.

We use a shell script (`sync-script/sync-satyadarshin-prod-to-dev.sh`) to sync the database and files from the production site into your dev environment. Once you've got the Docker system up and running, follow the instructions in `sync-script/sync-script.md` to set up the script.

This project is [based on work](https://github.com/AdhisthanaTriratna/adhisthana-docker-dev/tree/main) by Vilasamuni at Adhisthana, adapated with permission and thanks.

## Setup instructions

### Prerequisites

- [**Git**](https://git-scm.com/downloads) must be installed on your machine.
- [**Docker**](https://www.docker.com/) must be installed on your machine.

### Step-by-Step Setup

#### 1. Clone the Repository:

Clone this `GrandDesigner` repository to your local machine:

```bash
git clone <repository-url>
```

#### 2. Install the Web directory:

Obtain a copy of the website files, and place them in `GrandDesigner/web/`

#### 3. Create the `.env` file and configure variables:

In the `GrandDesigner` directory, copy `.env-example` to `.env` and set the database details. When you first start the Docker system, it will create a new database with the details you've specified. You can set the `MARIABD_*` variables to whatever you like with the exception of `MARIADB_HOST` which has to stay set as the name of the MariaDB container (defined in `docker-compose.yml`). The database passwords should be 16 characters randomly generated. 

#### 4. Start the Docker Containers:

Run the following command from the `GrandDesigner` directory to start
the Docker containers:

```bash
docker compose up -d
```

> **Note**: The first run may take some time while Docker downloads and installs the necessary
dependencies.

#### 5. Access the website:

You can access the development environment via the following URLs:

- **Website**: [https://localhost/](https://localhost/)
- **WordPress Admin**: [https://localhost/wp-admin/](https://localhost/wp-admin/)
- **phpMyAdmin**: [http://localhost:8080/](http://localhost:8080/)

### Stopping and restarting Docker:

- To stop the containers temporarily, run:

  ```bash
  docker compose stop
  ```

- To restart them, run:

  ```bash
  docker compose start
  ```

- To fully shut down and remove containers and networks, run:

  ```bash
  docker compose down
  ```

For a quick guide about running these commands, check out
[this guide](https://blog.christianlehnert.dev/how-to-halt-your-docker-containers-comparing-stop-and-down-commands-in-docker-compose).

---

## Troubleshooting

---

## Managing updates

Follow this repository on GitHub to recieve notifications about updates to the Docker config. 
When there is an update on the `main` branch, complete the following steps:

1. **Pull the latest version of our docker config**:
   ```bash
   git pull
   ```
2. **Pull latest versions of public images from Docker Hub**:
   ```bash
   docker compose pull
   ```
3. **Rebuild the Docker containers**:
   ```bash
   docker compose build
   ```
4. **Restart the Docker containers**:
   ```bash
   docker compose up
   ```

# DEV_DOC.md

## Developer Documentation

This document describes how a developer can set up, build, launch, and manage the Inception project.

---

## 1. Set up the environment from scratch

### Prerequisites

Ensure the following are installed:
- **Docker** (version 29.2.1+)
- **Docker Compose** (Docker Compose version v2.15.1+)
- **Make** (GNU Make 4.3+)

### Configure the environment

Create and configure `srcs/.env` with:

```env example :
DOMAIN_NAME=YOUR_DOMAIN.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wppass
USER=alandel
MYSQL_ROOT_PASSWORD=rootpass
WP_ADMIN_USER=superuser
WP_ADMIN_PASSWORD=superpass
WP_ADMIN_EMAIL=admin@mail.com
WP_USER=user42
WP_USER_PASSWORD=userpass
WP_USER_EMAIL=user@mail.com
```

**Important:** Never commit `.env` to version control. Add it to `.gitignore`.

---

## 2. Build and launch the project

### Start the stack

```bash
make
```

This will:
- Create data directories (`/home/login/data`)
- Build Docker images
- Create and start all containers
- Set up the Docker network

### Verify everything is running

```bash
make ps
```

All three containers should be running: `nginx`, `wordpress`, and `mariadb`.

---

## 3. Manage containers and volumes

### Available commands

```bash
make up         # Start all services
make start      # Start stopped containers
make stop       # Stop containers
make restart    # Restart containers
make down       # Remove containers and network (keeps data)
make clean      # Remove containers, network, and volumes
make fclean     # Complete cleanup (deletes all data)
make re         # Restart from scratch (fclean + up)
make ps         # List containers
make logs       # View logs
```

```bash
docker compose up                  # Start all services
docker compose start               # Start stopped containers
docker compose stop                # Stop containers
docker compose restart             # Restart containers
docker compose down                # Remove containers and network (keeps data)
docker compose down -v             # Remove containers, network, and volumes
docker compose down --rmi all -v   # Complete cleanup (deletes all data)
docker compose up --build          # Build and start from scratch
docker compose ps                  # List containers
docker compose logs                # View logs
docker compose build               # Build images only
```

### View logs

```bash
make logs
docker logs inception_wordpress_1
docker logs -f inception_mariadb_1
```

### Access containers

```bash
docker exec -it wordpress ls -la /var/www/html
docker exec -it mariadb mariadb -u root -p -e "SHOW DATABASES"
docker exec -it mariadb mariadb -u wpuser -p -e "USE wordpress; SHOW TABLES;"
```

### Access volumes

```bash
docker volume ls
docker volume inspect inception_mariadb_data
docker volume inspect inception_wordpress_data
```

---

## 4. Data storage and persistence

### Data locations

All persistent data is stored on the host machine:

```
/home/login/data
├── wordpress/    # WordPress files and configuration
└── mariadb/      # Database files
```

### How persistence works

- **WordPress volume:** `/home/login/data/wordpress` → `/var/www/html` in container
- **MariaDB volume:** `/home/login/data/mariadb` → `/var/lib/mysql` in container

All changes in the containers are automatically saved to these directories on the host.

### Data persistence across restarts

Data persists when:
- Stopping and starting containers: `make stop` → `make up`
- Removing containers: `make down` → `make up`

Data is **deleted only with**:
- `make fclean` (removes data directories)

---

## Summary of commands

| Task | Command |
|------|---------|
| Start project | `make / make up` |
| Stop containers | `make stop` |
| View status | `make ps` |
| View logs | `make logs` |
| Restart | `make restart` |
| Remove containers | `make down` |
| Complete cleanup | `make fclean` |
| Restart from scratch | `make re` |
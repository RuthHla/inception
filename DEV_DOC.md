# DEV_DOC.md

## Developer Documentation

This document describes how a developer can set up, build, launch, and manage the Inception project.

---

## 1. Set up the environment from scratch

### Prerequisites

Ensure the following are installed:
- **Docker** (version 20.10+)
- **Docker Compose** (version 1.29+)
- **Make** (GNU Make 4.0+)

### Project structure

```
inception/
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   ├── requirements/
│   │   ├── nginx/
│   │   ├── wordpress/
│   │   └── mariadb/
│   └── conf/
└── USER_DOC.md / DEV_DOC.md / README.md
```

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

or

```bash
make up
```

This will:
- Create data directories (`~/data/wordpress` and `~/data/mariadb`)
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

### View logs

```bash
make logs
docker logs inception_wordpress_1
docker logs -f inception_mariadb_1
```

### Access containers

```bash
docker exec -it inception_wordpress_1 /bin/bash
docker exec -it inception_mariadb_1 mysql -u root -p
```

---

## 4. Data storage and persistence

### Data locations

All persistent data is stored on the host machine:

```
~/data/
├── wordpress/    # WordPress files and configuration
└── mariadb/      # Database files
```

### How persistence works

- **WordPress volume:** `~/data/wordpress` → `/var/www/html` in container
- **MariaDB volume:** `~/data/mariadb` → `/var/lib/mysql` in container

All changes in the containers are automatically saved to these directories on the host.

### Data persistence across restarts

Data persists when:
- Stopping and starting containers: `make stop` → `make up`
- Removing containers: `make down` → `make up`

Data is **deleted only with**:
- `make fclean` (removes data directories)

### Backup and restore

Backup:
```bash
tar -czf backup.tar.gz ~/data/
```

Restore:
```bash
make stop
tar -xzf backup.tar.gz -C ~/
make up
```

---

## Summary of commands

| Task | Command |
|------|---------|
| Start project | `make up` |
| Stop containers | `make stop` |
| View status | `make ps` |
| View logs | `make logs` |
| Restart | `make restart` |
| Remove containers | `make down` |
| Complete cleanup | `make fclean` |
| Restart from scratch | `make re` |
# USER_DOC.md

## Understand what services are provided by the stack

This mini web infrastructure provides access to a WordPress website through three Docker services:

- **NGINX**: the single entry point of the infrastructure, accessible through **HTTPS on port 443**
- **WordPress**: the website itself and its administration panel
- **MariaDB**: the database used by WordPress

---

## Start and stop the project

### Initial setup and start

After filling the `srcs/.env` file with your own values, run:

```bash
make
```

This command will:
- create the necessary data directories
- build all required Docker images
- create and start all services
- create persistent data volumes
- configure the Docker network

### Available make commands

```bash
make up        # Start all services (creates directories and builds if needed)
make start     # Start stopped containers
make stop      # Stop the running containers
make restart   # Restart all containers
make down      # Stop and remove containers and the network
make clean     # Remove containers, network, and volumes
make fclean    # Complete cleanup: remove containers, images, volumes, and data directories
make re        # Restart from scratch (equivalent to: fclean + up)
make ps        # List running containers
make logs      # View logs from all services
```

**⚠️ Important:**
- `make clean` removes Docker volumes but keeps the data directories
- `make fclean` performs a complete cleanup and deletes all persisted project data (WordPress and MariaDB)

---

## Access the website and the administration panel

Once the project is running, the website is accessible at:

```
https://<your_domain_name>
```

The WordPress administration panel is available at:

```
https://<your_domain_name>/wp-admin
```

The domain name must match the value defined in your `srcs/.env` file (typically in the `DOMAIN_NAME` or similar variable).

---

## Locate and manage credentials

All credentials are stored in the `srcs/.env` file. Make sure to fill in the following values before launching the project:

- **WordPress administrator username and password**
- **WordPress database username and password**
- **MariaDB root password**
- **MariaDB database name**
- **Domain name** (must be accessible via HTTPS)
- Any other configuration variables required by your Docker services

---

## Check that the services are running correctly

### Verify running containers

To check that the containers are running correctly, use:

```bash
make ps
```

You should see three containers running: `nginx`, `wordpress`, and `mariadb`.

### Inspect logs

To view logs from all services:

```bash
make logs
```

To view logs from a specific service:

```bash
docker logs <service_name>
```

Replace `<service_name>` with `nginx`, `wordpress`, or `mariadb`.

### Test HTTPS connectivity

To test that the website is reachable through HTTPS, use:

```bash
curl -vk https://<your_domain_name>
```

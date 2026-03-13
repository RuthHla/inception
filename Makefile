NAME = inception

COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env

DATA_PATH = /home/$(USER)/data
WP_DATA = $(DATA_PATH)/wordpress
DB_DATA = $(DATA_PATH)/mariadb

all: up

$(WP_DATA):
	mkdir -p $(WP_DATA)

$(DB_DATA):
	mkdir -p $(DB_DATA)

dirs: $(WP_DATA) $(DB_DATA)

build: dirs
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) build

up: dirs
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) up -d --build

down:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down

start:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) start

stop:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) stop

restart:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) restart

logs:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) logs

logs-f:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) logs -f

ps:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) ps

clean:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down -v

fclean: clean
	docker system prune -af
	sudo rm -rf $(WP_DATA)
	sudo rm -rf $(DB_DATA)

re: fclean up

.PHONY: all dirs build up down start stop restart logs logs-f ps clean fclean re
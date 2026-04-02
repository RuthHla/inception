COMPOSE = docker compose
COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env

DATA_PATH = /home/$(USER)/data
WP_DATA = $(DATA_PATH)/wordpress
DB_DATA = $(DATA_PATH)/mariadb

# AJOUTER la modif /etc/hosts

all: up

$(WP_DATA):
	mkdir -p $(WP_DATA)

$(DB_DATA):
	mkdir -p $(DB_DATA)

dirs: $(WP_DATA) $(DB_DATA)

build: dirs
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) build --no-cache

up: dirs
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) build --no-cache
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

ps:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) ps

clean:
	$(COMPOSE) --env-file $(ENV_FILE) -f $(COMPOSE_FILE) down -v

#attention au sudo
# prune supprime toutes les images et -af force la suppressions de tous types dimages
fclean: clean
	docker system prune -af
	sudo rm -rf $(WP_DATA) 
	sudo rm -rf $(DB_DATA)

re: fclean up

.PHONY: all dirs build up down start stop restart logs ps clean fclean re
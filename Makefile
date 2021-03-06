LARADOCK_REPO = git@github.com:laradock/laradock.git
LARADOCK_BRANCH = v5.8.0
DOCKER_COMPOSE := $(shell which docker-compose) -f laradock/docker-compose.yml
MAKE := $(shell which make)

DB_USER = default
DB_PASSWORD = secret
DB_NAME = default

help:
	cat ./Makefile

setup: install up

install: laradock

up: laradock
	$(DOCKER_COMPOSE) up -d --build workspace nginx php-fpm mysql

down: laradock
	$(DOCKER_COMPOSE) down

laradock:
	git clone -b $(LARADOCK_BRANCH) $(LARADOCK_REPO)
	$(MAKE) laradock/env

laradock/env: laradock
	cp ./env-example ./laradock/.env
	ln -sf ./laradock/.env .env

db: install
	$(DOCKER_COMPOSE) exec mysql mysql -u$(DB_USER) -p$(DB_PASSWORD) $(DB_NAME)

ps:
	$(DOCKER_COMPOSE) ps

ssh/workspace: install
	$(DOCKER_COMPOSE) exec workspace bash

clean:
	rm -rf ./laradock

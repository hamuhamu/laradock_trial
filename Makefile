.PHONY: help

LARADOCK_REPO = git@github.com:laradock/laradock.git
LARADOCK_BRANCH = v5.8.0
DOCKER_COMPOSE := $(shell which docker-compose) -f laradock/docker-compose.yml
MAKE := $(shell which make)

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
	$(MAKE) laradock/patch/apply

laradock/patch/apply: laradock
	cp ./laradock/env-example ./laradock/.env
	ln -sf ./laradock/.env .env

db: install
	$(DOCKER_COMPOSE) exec mysql mysql -udefault -psecret default

ps:
	$(DOCKER_COMPOSE) ps

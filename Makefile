# Run this targets on host machine

include .env
export

all: | build up

.PHONY: build
build:
	docker compose -p ${PROJECT_NAME} build --pull --force-rm --no-cache

.PHONY: up
up: | docker-up

.PHONY: down
down: | docker-down

.PHONY: restart
restart: | docker-restart

.PHONY: docker-up
docker-up:
	docker compose -p ${PROJECT_NAME} up -d --force-recreate

.PHONY: docker-down
docker-down:
	docker compose -p ${PROJECT_NAME} down -t 3

.PHONY: docker-restart
docker-restart:
	docker compose -p ${PROJECT_NAME} restart -t 1

.PHONY: sh
sh:
	docker compose -p ${PROJECT_NAME} exec app sh

.PHONY: bash
bash:
	docker compose -p ${PROJECT_NAME} exec app bash

.PHONY: test
test:
	docker compose -p ${PROJECT_NAME} exec -T app make -f Makefile.native test

.PHONY: create
create:
	docker compose -p ${PROJECT_NAME}  exec -T app make -f Makefile.native create

.PHONY: migrate
migrate:
	docker compose -p ${PROJECT_NAME}  exec -T app make -f Makefile.native migrate
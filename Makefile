name = inception

all:
	@printf "Launch configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_folders.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

build:
	@printf "Building configuration ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_folders.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

re: down
	@printf "Rebuild configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/* ~/data/wordpress/.* 2>/dev/null || true
	@sudo rm -rf ~/data/mariadb/* ~/data/mariadb/.* 2>/dev/null || true

fclean:
	@printf "Total clean of all configurations docker\n"
	@docker stop $$(docker ps -qa) || true
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/wordpress/* ~/data/wordpress/.* 2>/dev/null || true
	@sudo rm -rf ~/data/mariadb/* ~/data/mariadb/.* 2>/dev/null || true

.PHONY: all build down re clean fclean

APP_PATH = /home/$(USER)/data

# Colors
BOLD = \033[1m
NC = \033[0m

all: prepare
	@docker compose -f ./srcs/docker-compose.yml up -d --build

status:
	@echo "$(BOLD)=== Docker Status ===$(NC)"
	@echo "$(BOLD)Containers:$(NC)"
	@docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
	@echo "$(BOLD)Volumes:$(NC)"
	@docker volume ls
	@echo "$(BOLD)Images:$(NC)"
	@docker images
	@echo "$(BOLD)Networks:$(NC)"
	@docker network ls
	@echo "$(BOLD)=== End of Docker Status ===$(NC)"

prepare:
	@mkdir -p $(APP_PATH)/wordpress
	@mkdir -p $(APP_PATH)/mariadb
	@mkdir -p ./srcs/secrets

down:
	@docker compose -f ./srcs/docker-compose.yml down

re:
	@docker compose -f ./srcs/docker-compose.yml up -d --build

clean: down
	@docker system prune -af

fclean: clean
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi
	@if [ -n "$$(docker ps -qa)" ]; then docker rm -f $$(docker ps -qa); fi
	@if [ -n "$$(docker images -q)" ]; then docker rmi -f $$(docker images -q); fi
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls --format '{{.Name}}' | grep -vE 'bridge|host|none')" ]; then \
		docker network rm $$(docker network ls --format '{{.Name}}' | grep -vE 'bridge|host|none'); \
	fi
	@docker system prune -af
	@sudo rm -rf $(APP_PATH)

.PHONY: all down re clean fclean

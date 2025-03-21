NAME			= Inception
USER			= jhogonca

SYSTEM_USER		= $(shell whoami)
DOCKER_CONFIG 	= $(shell echo $$HOME)/.docker

SRC_DIR			= ./srcs
VOL_DIR			= /home/$(SYSTEM_USER)/data

WP_NAME			= wordpress
MDB_NAME		= mariadb

all:		volumes hosts up help

volumes:
			@echo "${YELLOW}-----Creating Docker Volumes-----${NC}"
			sudo mkdir -p ${VOL_DIR}/${WP_NAME}
			sudo docker volume create --driver local --opt type=none --opt device=${VOL_DIR}/${WP_NAME} --opt o=bind ${WP_NAME}
			sudo mkdir -p ${VOL_DIR}/${MDB_NAME}
			sudo docker volume create --driver local --opt type=none --opt device=${VOL_DIR}/${MDB_NAME} --opt o=bind ${MDB_NAME}
			@echo "${GREEN}-----Volumes Created-----${NC}"

hosts:
			@echo "${YELLOW}-----Editing hosts file with domain name-----${NC}"
			@if ! grep -qFx "127.0.0.1 ${USER}.42.fr" /etc/hosts; then \
				sudo sed -i '2i\127.0.0.1\t${USER}.42.fr' /etc/hosts; \
			fi
			@echo "${GREEN}-----Hosts file edited-----${NC}"

up:
			@echo "${YELLOW}-----Starting Docker-----${NC}"
			sudo docker compose -f ${SRC_DIR}/docker-compose.yml up -d --build
			@echo "${GREEN}-----Docker Started-----${NC}"

down:
			@echo "${YELLOW}-----Stopping Docker-----${NC}"
			@docker compose -f ${SRC_DIR}/docker-compose.yml down
			@echo "${GREEN}-----Docker Stopped-----${NC}"

clean:		down

re:			down all

prepare:	update compose

update:
			@echo "${YELLOW}-----Updating System----${NC}"
			sudo apt -y update && sudo apt -y upgrade
			@if [ $$? -eq 0 ]; then \
				echo "${GREEN}-----System updated-----${NC}"; \
				echo "${YELLOW}-----Installing Docker-----${NC}"; \
				sudo apt -y install docker.io && sudo apt -y install docker-compose; \
				if [ $$? -eq 0 ]; then \
					echo "${GREEN}-----Docker and docker-compose installed-----${NC}"; \
				else \
					echo "${RED}-----Docker or docker-compose installation failed-----${NC}"; \
				fi \
			else \
				echo "${RED}-----System update failed-----${NC}"; \
			fi

compose:
			@echo "${YELLOW}-----Updating Docker Compose to V2-----${NC}"
			sudo apt -y install curl
			mkdir -p ${DOCKER_CONFIG}/cli-plugins
			curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 \
					-o ${DOCKER_CONFIG}/cli-plugins/docker-compose
			chmod +x ${DOCKER_CONFIG}/cli-plugins/docker-compose
			sudo mkdir -p /usr/local/lib/docker/cli-plugins
			sudo mv /home/${SYSTEM_USER}/.docker/cli-plugins/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
			@echo "${GREEN}-----Docker Compose updated-----${NC}"

status:
	clear
		@echo "$(BOLD)\t\t=== Docker Status ===$(NC)"
		@echo "$(BOLD)\nNetworks:$(NC)"
		@docker network ls
		
		@echo "$(BOLD)\nVolumes:$(NC)"
		@docker volume ls

		@echo "$(BOLD)\nContainers:$(NC)"
		@docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
		
		@echo "$(BOLD)\nImages:$(NC)"
		@docker images
		
		@echo "$(BOLD)\n\t\t=== End of Docker Status ===$(NC)\n"

help:
	clear
	@echo "${GREEN}#-----------------------------------------------------------------------#${NC}"
	@echo "${GREEN}#\tWelcome to ${NAME} by ${USER}\t\t\t\t#${NC}"
	@echo "${GREEN}#\tWordpress is running at ${USER}.42.fr\t\t\t\t#${NC}"
	@echo "${GREEN}#\tTo access wordpress admin, go to ${USER}.42.fr/wp-admin\t#${NC}"
	@echo "${GREEN}#\tTo access Adminer, go to ${USER}.42.fr/adminer.php\t\t#${NC}"
	@echo "${GREEN}#\tTo access The static website, go to ${USER}.42.fr:7777\t\t#${NC}"
	@echo "${GREEN}#\tTo access The CAdvisor, go to ${USER}.42.fr:8080\t\t#${NC}"
	@echo "${GREEN}#-----------------------------------------------------------------------#${NC}"
	@echo "\n"

fclean: clean
			@echo "${YELLOW}-----Removing Docker Volumes-----${NC}"
			docker volume rm ${WP_NAME}
			sudo rm -rf /home/$(SYSTEM_USER)/data/${WP_NAME}
			docker volume rm ${MDB_NAME}
			sudo rm -rf /home/$(SYSTEM_USER)/data/${MDB_NAME}
			@echo "${RED}-----Volumes Removed-----${NC}"
			@echo "${YELLOW}-----Removing domain name from hosts file-----${NC}"
			sudo sed -i '/127\.0\.0\.1\t${USER}\.42\.fr/d' /etc/hosts
			@echo "${RED}-----Hosts file edited-----${NC}"
			@docker system prune -af
			@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi
			@if [ -n "$$(docker ps -qa)" ]; then docker rm -f $$(docker ps -qa); fi
			@if [ -n "$$(docker images -q)" ]; then docker rmi -f $$(docker images -q); fi
			@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
			@if [ -n "$$(docker network ls --format '{{.Name}}' | grep -vE 'bridge|host|none')" ]; then \
				docker network rm $$(docker network ls --format '{{.Name}}' | grep -vE 'bridge|host|none'); \
			fi
			@docker system prune -af
			@sudo rm -rf $(APP_PATH)

certificate:
	openssl s_client -connect $(USER).42.fr:443

PHONY:		all clean re prepare update compose status fclean

# Colors
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
NC = \033[0m
BOLD = \033[1m
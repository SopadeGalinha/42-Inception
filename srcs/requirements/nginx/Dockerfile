# Base image
FROM 		debian:bullseye

# Define build arguments passed from docker-compose.yml
ARG			DOMAIN_NAME
ARG 		CERTS_KEY
ARG			CERTS_CRT

# Update and upgrade system & install Nginx and OpenSSL
RUN 		apt-get -y update && apt-get -y upgrade
RUN 		apt-get -y install nginx openssl 

# Generate self-signed certificate
RUN 		openssl req -x509 -sha256 -nodes \
			-newkey rsa:4096 \
			-days 365 \
			-subj "/C=PT/ST=Porto/L=Porto/O=42PT/OU=Inception/CN=jhogonca.42.fr" \
			-keyout ${CERTS_KEY} \
			-out ${CERTS_CRT}

# Guarantee that Nginx is using TSLv1.3 
RUN 		sed -i 's/ssl_protocols.*/ssl_protocols TLSv1.3;/' /etc/nginx/nginx.conf

# Copy configuration files
COPY 		./conf/https.conf /etc/nginx/conf.d/
RUN			sed -i "s|INSERT_DOMAIN_NAME_HERE|${DOMAIN_NAME}|g" /etc/nginx/conf.d/https.conf
RUN 		sed -i "s|INSERT_KEY_PATH_HERE|${CERTS_KEY}|g" /etc/nginx/conf.d/https.conf
RUN 		sed -i "s|INSERT_CRT_PATH_HERE|${CERTS_CRT}|g" /etc/nginx/conf.d/https.conf
COPY 		./conf/http.conf /etc/nginx/conf.d/
RUN			sed -i "s|INSERT_DOMAIN_NAME_HERE|${DOMAIN_NAME}|g" /etc/nginx/conf.d/https.conf

# Expose ports
EXPOSE 		443

# Run NGINX
ENTRYPOINT	[ "nginx", "-g", "daemon off;" ]

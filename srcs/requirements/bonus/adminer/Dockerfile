# Base image
FROM debian:bullseye

# Update and upgrade system & install packages
RUN apt-get update && apt-get -y upgrade && apt-get -y install wget php7.4 php7.4-fpm

# Expose port 9000
EXPOSE 9000

# Copy Entrypoint script
COPY ./tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["bash", "/usr/local/bin/entrypoint.sh"]

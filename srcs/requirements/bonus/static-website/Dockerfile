# Use the debian:bullseye as base image
FROM debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y \
    nginx \
 && rm -rf /var/lib/apt/lists/*

# Copy the static HTML file to the nginx directory
COPY src/index.html /var/www/html/index.html

# Expose the default nginx port
EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]

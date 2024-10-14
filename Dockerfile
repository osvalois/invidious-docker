# Use the official Crystal image as base
FROM crystallang/crystal:1.7.2-alpine

# Install dependencies
RUN apk add --no-cache git postgresql-client ffmpeg

# Clone the Invidious repository
RUN git clone https://github.com/iv-org/invidious.git /invidious

# Set working directory
WORKDIR /invidious

# Install dependencies and build Invidious (excluding ameba)
RUN shards install --without-development && \
    crystal build src/invidious.cr --release

# Install NGINX
RUN apk add --no-cache nginx

# Copy NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy config.yml with performance tuning
COPY config.yml /invidious/config/config.yml

# Install http3-ytproxy
RUN mkdir -p /opt/http3-ytproxy && \
    chown nobody:nobody /opt/http3-ytproxy

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 3000
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
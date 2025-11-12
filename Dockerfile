FROM nginx:1.17

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

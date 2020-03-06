FROM nginx:1.17-alpine

COPY index.html swagger.yml /usr/share/nginx/html/
COPY nginx.default.conf /etc/nginx/conf.d/default.conf

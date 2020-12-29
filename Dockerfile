FROM nginx:1.19.6-alpine
COPY proxy.conf /etc/nginx/conf.d/proxy.conf
COPY resolf.conf /etc/resolv.conf
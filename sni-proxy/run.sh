#!/bin/bash -ex

cp -f /etc/nginx/nginx.tmpl /etc/nginx/nginx.conf
sed -i -e "s/APIM/${APIM_DNS}/g" /etc/nginx/nginx.conf
sed -i -e "s/PORTAL/${PORTAL_DNS}/g" /etc/nginx/nginx.conf
sed -i -e "s/GATEWAY/${GATEWAY_DNS}/g" /etc/nginx/nginx.conf
cat /etc/nginx/nginx.conf
exec nginx -g "daemon off;"
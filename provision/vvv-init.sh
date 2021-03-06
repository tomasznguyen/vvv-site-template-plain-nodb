#!/usr/bin/env bash

# Site environment
if [ ! -f "${VVV_PATH_TO_SITE}/site/public_html" ] ; then
  mkdir -p "${VVV_PATH_TO_SITE}/site/public_html"
fi

# Nginx Logs
mkdir -p "${VVV_PATH_TO_SITE}/log"
touch "${VVV_PATH_TO_SITE}/log/nginx-error.log"
touch "${VVV_PATH_TO_SITE}/log/nginx-access.log"

# Nginx configuration
cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"

if [ -n "$(type -t is_utility_installed)" ] && [ "$(type -t is_utility_installed)" = function ] && `is_utility_installed core tls-ca`; then
    sed -i "s#{{TLS_CERT}}#ssl_certificate /vagrant/certificates/${VVV_SITE_NAME}/dev.crt;#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
    sed -i "s#{{TLS_KEY}}#ssl_certificate_key /vagrant/certificates/${VVV_SITE_NAME}/dev.key;#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
else
    sed -i "s#{{TLS_CERT}}##" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
    sed -i "s#{{TLS_KEY}}##" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
fi

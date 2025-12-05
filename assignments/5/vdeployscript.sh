#!/bin/bash

set -e

# ==================== VARIABLES ====================
TMP_DIR="/tmp/sitedeploy"
APP_DIR="/var/www/html/app3"
NGINX_SITE="/etc/nginx/sites-available/app3"
DOMAIN="highway.com"
ZIP_URL="https://templatemo.com/tm-zip-files-2020/templatemo_520_highway.zip"
ZIP_NAME="templatemo_520_highway.zip"
SITE_FOLDER="templatemo_520_highway"
# ===================================================

sudo apt update -y
sudo apt install curl wget nginx unzip -y

sudo systemctl start nginx
sudo systemctl enable nginx


###########################################################################

# Temporary directory setup
if [ -d "$TMP_DIR" ]; then
    echo "dir already exists ,cleaning it..."
    sudo rm -rf "$TMP_DIR"
    mkdir "$TMP_DIR"
    echo "dir created successfully after cleaning"
else
    mkdir "$TMP_DIR"
    echo "dir created successfully"
fi


###########################################################################

cd "$TMP_DIR"
wget "$ZIP_URL"
unzip -o "$ZIP_NAME"


###########################################################################

# App directory setup
if [ -d "$APP_DIR" ]; then
    echo "dir already exists ,cleaning it..."
    sudo rm -rf "$APP_DIR"
    sudo mkdir "$APP_DIR"
    echo "dir created successfully after cleaning"
else
    sudo mkdir -p "$APP_DIR"
    echo "dir created successfully"
fi


###########################################################################

sudo cp -r "$TMP_DIR/$SITE_FOLDER/"* "$APP_DIR"

if [ $? -eq 0 ]; then
    echo "copying done."
else
    echo "copying failed"
    exit 1
fi

sudo chown -R www-data:www-data "$APP_DIR"


###########################################################################

# Nginx configuration file
if [ -f "$NGINX_SITE" ]; then
    echo "file already exists ,cleaning it..."
    sudo rm -f "$NGINX_SITE"
fi

sudo tee "$NGINX_SITE" > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $APP_DIR;
    index index.html index.htm index.php;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~* \.(jpg|jpeg|png|gif|css|js|svg|ico)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }
}
EOF
echo "nginx site config created successfully"


###########################################################################

# Enable site (symlink)
if [ -L /etc/nginx/sites-enabled/app3 ]; then
    echo "link already exists ,removing it..."
    sudo rm -f /etc/nginx/sites-enabled/app3
fi

sudo ln -s "$NGINX_SITE" /etc/nginx/sites-enabled/app3
echo "link created successfully"


###########################################################################

# Add domain to /etc/hosts
if grep -Fxq "127.0.0.1 $DOMAIN" /etc/hosts; then
    echo "already exists in hosts"
else
    echo "127.0.0.1 $DOMAIN" | sudo tee -a /etc/hosts
    echo "append successfully"
fi


###########################################################################

sudo nginx -t || { echo "error in nginx config file"; exit 1; }

sudo systemctl reload nginx || { echo "failed to reload"; exit 1; }

sleep 2
curl -I "http://$DOMAIN" | grep -Fqi "200 OK"

if [ $? -eq 0 ]; then
    echo "Application is accessible.."
else
    echo "Application not reachable!!!"
    exit 1
fi

###########################################################################

echo "deployment completed ✅"
echo "Access app at: http://$DOMAIN"

exit 0
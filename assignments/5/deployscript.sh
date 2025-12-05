#!/bin/bash


set -e


sudo apt update -y
sudo apt install curl wget nginx unzip -y

sudo systemctl start nginx
sudo systemctl enable nginx


###########################################################################


if [ -d /tmp/sitedeploy ]; then
        echo "dir already exists ,cleaning it..."
        sudo rm -rf /tmp/sitedeploy
        mkdir /tmp/sitedeploy
        echo "dir created successfully after cleaning"
else
        mkdir /tmp/sitedeploy
        echo "dir created successfully"
fi


############################################################################


cd /tmp/sitedeploy/
wget https://templatemo.com/tm-zip-files-2020/templatemo_520_highway.zip
unzip -o templatemo_520_highway.zip


############################################################################


if [ -d /var/www/html/app3 ]; then
        echo "dir already exists ,cleaning it..."
        sudo rm -rf /var/www/html/app3
        sudo mkdir /var/www/html/app3
        echo "dir created successfully after cleaning"
else
        sudo mkdir -p /var/www/html/app3
        echo "dir created successfully"
fi


#############################################################################


sudo cp -r /tmp/sitedeploy/templatemo_520_highway/* /var/www/html/app3

if [ $? -eq 0 ]; then
        echo "coping done."
else
        echo "coping failed"
        exit 1
fi


sudo chown -R www-data:www-data /var/www/html/app3


#############################################################################


if [ -f /etc/nginx/sites-available/app3 ]; then
        echo "file already exists ,cleaning it..."
        sudo rm -f /etc/nginx/sites-available/app3
        sudo tee /etc/nginx/sites-available/app3 > /dev/null <<EOF
server {
    listen 80;
    server_name highway.com;

    root /var/www/html/app3;
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
        echo "file recreated successfully"
else
        sudo tee /etc/nginx/sites-available/app3 > /dev/null <<EOF
server {
    listen 80;
    server_name highway.com;

    root /var/www/html/app3;
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
        echo "file created successfully"
fi


#############################################################################


if [ -L /etc/nginx/sites-enabled/app3 ]; then
        echo "link already exists ,removing it..."
        sudo rm -f /etc/nginx/sites-enabled/app3
        sudo ln -s /etc/nginx/sites-available/app3 /etc/nginx/sites-enabled/app3
        echo "link recreated successfully"
else
        sudo ln -s /etc/nginx/sites-available/app3 /etc/nginx/sites-enabled/app3
        echo "link created successfully"
fi


#############################################################################


if grep -Fxq "127.0.0.1 highway.com" /etc/hosts; then
        echo "already exists"
else
        echo "127.0.0.1 highway.com" | sudo tee -a /etc/hosts
        echo "append successfully"
fi


#############################################################################



sudo nginx -t || { echo "error in nginx config file"; exit 1; }



#############################################################################


sudo systemctl reload nginx || { echo "failed to reload"; exit 1; }



sleep 2
curl -I http://highway.com | grep -Fqi "200 OK"

if [ $? -eq 0 ]; then
        echo "Application is accessible.."
else
        echo "Application not reachable!!!"
        exit 1
fi



#############################################################################



echo "deployment completed"
echo "access to app at : http://highway.com"




exit 0

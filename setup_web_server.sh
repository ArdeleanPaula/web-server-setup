#!/bin/bash

# Functie pentru instalare Apache sau Nginx pe diferite distributii
function install_web_server {
    if [ -f /etc/debian_version ]; then
        echo "Detected Debian/Ubuntu"
        sudo apt update
        if [ "$1" == "apache" ]; then
            sudo apt install apache2 -y
            sudo systemctl start apache2
            sudo systemctl enable apache2
            sudo echo "Apache Installed!"
        elif [ "$1" == "nginx" ]; then
            sudo apt install nginx -y
            sudo systemctl start nginx
            sudo systemctl enable nginx
            sudo echo "Nginx Installed!"
        fi
    elif [ -f /etc/redhat-release ]; then
        echo "Detected CentOS/RHEL"
        sudo yum update -y
        if [ "$1" == "apache" ]; then
            sudo yum install httpd -y
            sudo systemctl start httpd
            sudo systemctl enable httpd
            sudo echo "Apache Installed!"
        elif [ "$1" == "nginx" ]; then
            sudo yum install nginx -y
            sudo systemctl start nginx
            sudo systemctl enable nginx
            sudo echo "Nginx Installed!"
        fi
    else
        echo "Unsupported Linux distribution"
    fi
}

# Crearea paginii HTML
function create_html {
    local web_root=""
    if [ "$1" == "apache" ]; then
        web_root="/var/www/html"
    elif [ "$1" == "nginx" ]; then
        web_root="/usr/share/nginx/html"
    fi

    sudo bash -c "cat > $web_root/index.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Server</title>
</head>
<body>
    <h1>Hello, this is a static website served by $1!</h1>
</body>
</html>
EOF
    echo "HTML file created at $web_root"
}

# Alegere intre Apache sau Nginx
read -p "Do you want to install Apache or Nginx? (apache/nginx): " server_choice
install_web_server $server_choice
create_html $server_choice

echo "Installation and configuration complete. Visit your server's IP address in a web browser."


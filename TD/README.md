# TD

##Week 1

**Partie 1 - IAAS**

1. Création d'un compte AWS
    * Création d'un user IAM (programmatic access)
    * setup access_key et secret_key dans .aws/credentials
    * setup .aws/config (region : eu-west-3)
    * ajouter votre code promo 50$ dans “billing dashboard” => credits

2. Démarrage d'une instance
    * t2.micro
    * Amazon Linux AMI 2018.03.0 (ami-047bb4163c506cd98)
    * Créer une nouvelle keypair
    * se connecter en ssh à l'instance (username : `ec2-user`)
3. Installation de Nginx + php + Mysql sur l'instance
    * Penser à laisser passer le traffic sur le port 80 via un security group
    * fichier `/etc/nginx/nginx.conf`
~~~~
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    index   index.php index.html index.htm;

    server {
        location /phpmyadmin {
               root /var/www/html;
               index index.php index.html index.htm;
               location ~ ^/phpmyadmin/(.+\.php)$ {
                       try_files $uri =404;
                       root /var/www/html;
                       fastcgi_pass   unix:/var/run/php-fpm/php-fpm.sock;
                        fastcgi_index  index.php;
                        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
                        include        fastcgi_params;
               }
               location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
                       root /var/www/html;
               }
        }
        location /pma {
               rewrite ^/* /phpmyadmin last;
        }
    }
}
~~~~
   * fichier `/etc/php-fpm.d/www.conf`
~~~~
[www]
user = nginx
group = nginx
listen = /var/run/php-fpm/php-fpm.sock
listen.acl_users = apache,nginx
listen.allowed_clients = 127.0.0.1
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
slowlog = /var/log/php-fpm/7.2/www-slow.log
php_admin_value[error_log] = /var/log/php-fpm/7.2/www-error.log
php_admin_flag[log_errors] = on
php_value[session.save_handler] = files
php_value[session.save_path]    = /tmp/
php_value[soap.wsdl_cache_dir]  = /var/lib/php/7.2/wsdlcache
~~~~
4. Installation et configuration de phpMyAdmin
    * Download https://files.phpmyadmin.net/phpMyAdmin/4.8.3/phpMyAdmin-4.8.3-all-languages.tar.gz
    * Vérifier que la page d'acceuil de phpMyadmin est bien disponible à l'adresse http://ip.de.votre.instance/pma

**Partie 2 - Managed Services**

1. Création d'une base de données RDS
    * Choisir la version 5.7.23     
    * type d'instance `db.t2.micro`
    * Multi-AZ deployment : NO 
    * Storage type : General Purpose (SSD)
    * Master username : `admin`
    * Master password : `unpasswordsuperlongettressecure`
    * Backup retention period : 0 days
    * Monitoring : Disable enhanced monitoring
    * Deletion protection : Décocher "Enable deletion protection"

2. Configuration de phpmyadmin sur cette base RDS

**Partie 3 - Terraform**
1. Installer terraform
    * https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
2. Création d'un VPC + Subnets + routage avec TF
3. Création des sécurity groups
4. Création d'une base RDS
5. Création d'une instance ec2
6. Installation de nginx, php et Phpmyadmin sur cette instance



## Week 2

**Partie 4 - Ansible**

1. Setup ansible vers l'instance terraformée 
    * OSX : `brew install ansible`

2. Provisionning de l'instance ec2 terraformée via un playbook
    * Un rôle par composant à installer

3. Installation et configuration de Nginx
4. Installation et configuration de php 
5. Installation et configuration de phpMyAdmin

**Partie 5 - Monitoring**

1. Installation d'un serveur Prometheus avec ansible + terraform
2. Monitoring de l'instance Prometheus avec node_exporter
3. Monitoring de l'instance phpmyadmin avec node_exporter





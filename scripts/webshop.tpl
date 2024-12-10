#cloud-config
hostname: webshop
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: ${password}       
    ssh_authorized_keys:
      - ${ssh_key}
# login ssh and console with password
ssh_pwauth: true
disable_root: false 
packages:
  - apache2
write_files:
 - content: |
    <html>
     <body>
      <h1>My Application</h1>
       <ul>
       <li><a href="/order">Order</a></li>
       <li><a href="/customer">Customer</a></li>
       <li><a href="/catalog">Catalog</a></li>
       </ul>
     </body>
    </html>
   path: /var/www/html/index.html
   permissions: '0644'  
 - content: |
    ProxyRequests Off
    <Proxy *>
          Order deny,allow
          Allow from all
    </Proxy>
    ProxyPass /order http://order         
    ProxyPassReverse /order http://order 
    ProxyPass /customer http://customer         
    ProxyPassReverse /customer http://customer  
    ProxyPass /catalog http://catalog         
    ProxyPassReverse /catalog http://catalog 
   path: /etc/apache2/sites-enabled/001-reverseproxy.conf
   permissions: '0644'  
runcmd:
 - sudo a2enmod proxy
 - sudo a2enmod proxy_html
 - sudo a2enmod proxy_http
 - sudo service apache2 restart

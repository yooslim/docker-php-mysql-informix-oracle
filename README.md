This is a docker services configuration that runs two containers :
 - A PHP container holding a LAMP environment AND which is able to manage Oracle and Informix distant DBMS.
 - A MySQL database container with persisted data.

### Container 1 : PHP-APP
This container represents a basic LAMP environment that has **PDO Informix** and **PDO OCI** enabled.

**Configuration :**
* PHP : 7.2
* Apache : 2.4.25
* PDO : oci, informix, mysql
![](https://image.ibb.co/guWnYU/Fire_Shot_Capture_5_phpinfo_http_localhost.png)
![](https://image.ibb.co/f23ef9/Fire_Shot_Capture_6_phpinfo_http_localhost.png)

### Container 2 : MYSQL-DB
This container is based on the official MySQL image, it will obviously creates a database container running MySQL 5.7.

### Installation
`docker-compose up -d --build`

You need to have port 80 and 3306 not occupied, otherwise change default ports that docker use for both containers (see docker-compose.yml).

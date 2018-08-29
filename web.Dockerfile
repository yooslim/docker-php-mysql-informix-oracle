FROM php:7.2-apache

########################################################################################################################
# ORACLE CONFIGURATION
########################################################################################################################

ENV LD_LIBRARY_PATH=/usr/local/instantclient_12_1/:/opt/IBM/informix/lib:/opt/IBM/informix/lib/esql:/opt/IBM/informix/lib/cli:/opt/IBM/informix/lib/c++:/opt/IBM/informix/lib/client:/opt/IBM/informix/lib/dmi
RUN export LD_LIBRARY_PATH=/usr/local/instantclient_12_1/:/opt/IBM/informix/lib:/opt/IBM/informix/lib/esql:/opt/IBM/informix/lib/cli:/opt/IBM/informix/lib/c++:/opt/IBM/informix/lib/client:/opt/IBM/informix/lib/dmi

RUN apt-get update
RUN apt-get install -y wget unzip zip nano libaio-dev git
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet
RUN mv composer.phar /usr/local/bin/composer

ADD ./oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip /tmp/
ADD ./oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip /tmp/
ADD ./oracle/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip /tmp/
RUN unzip /tmp/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN unzip /tmp/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip -d /usr/local/
RUN ln -s /usr/local/instantclient_12_1 /usr/local/instantclient
RUN ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so
RUN ln -s /usr/local/instantclient/libocci.so.12.1 /usr/local/instantclient/libocci.so
RUN ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus
RUN echo 'instantclient,/usr/local/instantclient' | pecl install oci8

RUN docker-php-ext-configure oci8 --with-oci8=shared,instantclient,/usr/local/instantclient
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/local/instantclient
RUN docker-php-ext-install oci8 pdo_oci pdo_mysql opcache

########################################################################################################################
# INFORMIX CONFIGURATION
########################################################################################################################

ADD ./informix/csdk /tmp/csdk
RUN echo "\n1\n\n\n\n\n" | /tmp/csdk/installclientsdk
ENV INFORMIXSQLHOSTS=/opt/IBM/informix/etc/sqlhosts.std
ENV INFORMIXSERVER=smokehp_tcp
ENV ODBCINI=/opt/IBM/informix/etc/odbc.ini
ENV INFORMIXDIR=/opt/IBM/informix
ENV PATH=$PATH:/opt/IBM/informix/bin

ADD ./informix/pdo /tmp/pdo
RUN tar zxf /tmp/pdo/PDO_INFORMIX-1.3.3.tgz -C /usr/local/src
RUN cd /usr/local/src/PDO_INFORMIX-1.3.3 \
&& phpize \
&& /usr/local/src/PDO_INFORMIX-1.3.3/configure --with-pdo-informix=/opt/IBM/informix \
&& make \
&& make install

RUN echo "extension=pdo_informix.so" > /usr/local/etc/php/conf.d/informix.ini

########################################################################################################################
# WEB CONFIGURATION
########################################################################################################################

COPY ./vhost.conf /etc/apache2/sites-available/000-default.conf
WORKDIR /var/www/php-app

RUN a2enmod rewrite
RUN service apache2 restart
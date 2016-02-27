FROM phusion/baseimage:latest
MAINTAINER Dirk Lüth <info@qoopido.com>

# Initialize environment
	CMD ["/sbin/my_init"]
	ENV DEBIAN_FRONTEND noninteractive

# based on dgraziotin/docker-osx-lamp
	ENV DOCKER_USER_ID 501 
	ENV DOCKER_USER_GID 20
	ENV BOOT2DOCKER_ID 1000
	ENV BOOT2DOCKER_GID 50

# Tweaks to give Apache/PHP write permissions to the app
	RUN usermod -u ${BOOT2DOCKER_ID} www-data && \
    	usermod -G staff www-data && \
    	groupmod -g $(($BOOT2DOCKER_GID + 10000)) $(getent group $BOOT2DOCKER_GID | cut -d: -f1) && \
    	groupmod -g ${BOOT2DOCKER_GID} staff
	
# install packages
	RUN apt-get update && \
		apt-get -qy upgrade && \
		apt-get -qy dist-upgrade && \
		apt-get install -qy php5-fpm \
			php5-common \
			php5-json \
			php5-gd \
			php5-curl \
			php5-mcrypt \
			php5-mysqlnd \
			php5-sqlite \
			php5-apcu \
			php5-memcached \
			php5-xdebug
			
# generate locales
	RUN cp /usr/share/i18n/SUPPORTED /var/lib/locales/supported.d/local && \
		locale-gen

# configure defaults
	ADD configure.sh /configure.sh
	ADD config /config
	RUN chmod +x /configure.sh && \
		chmod 755 /configure.sh
	RUN /configure.sh && \
		chmod +x /etc/my_init.d/*.sh && \
		chmod 755 /etc/my_init.d/*.sh && \
		chmod +x /etc/service/php55/run && \
		chmod 755 /etc/service/php55/run
		
# enable extensions
	RUN ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/fpm/conf.d/20-mcrypt.ini

# disable extensions
	RUN rm -rf /etc/php5/fpm/conf.d/20-xdebug.ini
		
# add default /app directory
	ADD app /app
	RUN mkdir -p /app/htdocs && \
		mkdir -p /app/data/sessions && \
		mkdir -p /app/data/logs && \
		mkdir -p /app/config

# cleanup
	RUN apt-get clean && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /configure.sh

# finalize
	VOLUME ["/app/htdocs", "/app/data", "/app/config"]
	EXPOSE 9000
	EXPOSE 9001

#!/bin/bash

restart() {
	if service --status-all | grep -Fq ${1}; then
		service ${1} restart
	fi
}

restart nginx
restart php7.0-fpm
restart mysql
restart mongodb
restart memcached
restart sphinxsearch
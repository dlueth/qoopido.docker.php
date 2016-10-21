tag?=develop

build:
	docker build --no-cache=true -t qoopido/php55:${tag} .
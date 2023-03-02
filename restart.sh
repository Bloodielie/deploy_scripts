#!/bin/bash

service_name="${1:-api}"
nginx_container_name="${2:-nginx}"

reload_nginx() {
  docker exec $nginx_container_name /usr/sbin/nginx -s reload
}

update_server() {
  old_container_id=$(docker ps -f name=$service_name -q | tail -n1)

  # create a new instance of the server
  echo "create second instance"
  docker-compose up --build -d --no-deps --scale $service_name=2 --no-recreate $service_name

  # wait for new container to be available
  echo "wait for new container to be available"
  new_container_id=$(docker ps -f name=$service_name -q | head -n1)
  new_container_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $new_container_id)
  curl --silent --include --retry-connrefused --retry 60 --retry-delay 1 --fail http://$new_container_ip:80/health_check || exit 1

  # ---- server is up ---

  echo "remove old container"
  # reload nginx, so it can recognize the new instance
  reload_nginx

  # take the old container offline
  docker stop $old_container_id
  docker rm $old_container_id

  docker-compose up -d --no-deps --scale $service_name=1 --no-recreate $service_name

  # reload ngnix, so it stops routing requests to the old instance
  reload_nginx

  echo "DONE !"
}

# call func
update_server
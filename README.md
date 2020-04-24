# Swarm Infrastructure

Losely based on https://dockerswarm.rocks

## Setup

Initialize swarm if not done already:

```bash
master_node=some-node-name
swarmmaster=$(docker-machine ip $master_node)

# then it will print a command to join the swarm
docker-machine ssh $master_node "sudo docker swarm init --advertise-addr $swarmmaster"

# for each slave node
docker-machine ssh ...SLAVE_NODES... "sudo [...that command...]" 

# verify
eval $(docker-machine env $master_node)
docker node ls
```



Create network first.

```bash
docker network create --driver overlay traefik-public
```

Fill in `.env`. For generating the password hash use `openssl passwd -apr1 YOUR_PASSWORD`

Tag node on which portainer should run:
```bash
NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add portainer.portainer-data=true $NODE_ID
```

Then deploy services, either by calling script:
```bash
./deploy_service.sh papertrail.yml
./deploy_service.sh traefik.yml
./deploy_service.sh portainer.yml
```

or manually:
```bash
docker-compose -f traefik.yml config | docker stack deploy --with-registry-auth --prune --compose-file - traefik
docker-compose -f papertrail.yml config | docker stack deploy --with-registry-auth --prune --compose-file - papertrail
docker-compose -f portainer.yml config | docker stack deploy --with-registry-auth --prune --compose-file - portainer
```

Then deploy a sample application:

```bash
docker-compose -f whoami.yml config | docker stack deploy --with-registry-auth --prune --compose-file - whoami
```

Access services via:
- https://traefik.YOUR_SERVICES_DOMAIN
- https://consul.YOUR_SERVICES_DOMAIN
- https://portainer.YOUR_SERVICES_DOMAIN

Access sample application via:
- https://whoami.YOUR_SERVICES_DOMAIN 
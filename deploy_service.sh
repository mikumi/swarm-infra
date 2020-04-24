if [ -z "$1" ]; then
    echo "Usage: ./deploy_service.sh YML_FILE"
    exit 1
fi

YML=$1
PROJECT=$(basename $YML .yml)

echo Deploying $PROJECT
set -o xtrace
docker-compose -f $YML config | docker stack deploy --with-registry-auth --prune --compose-file - $PROJECT
set +o xtrace
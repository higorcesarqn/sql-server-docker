docker-compose -f .\docker-compose.yml down --remove-orphans
docker-compose -f .\docker-compose.yml up -d --build

docker-compose -f .\docker-compose.yml ps
docker-compose -f .\docker-compose.yml logs 
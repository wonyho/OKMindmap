
#!/bin/bash
#use for Docker mode only

curl -L 'https://okmindmap.com/doc/okmindmap.tar' > $(pwd)/docker/okmindmap.tar
curl -L 'https://okmindmap.com/doc/okmindmapdb.tar' > $(pwd)/docker/okmindmapdb.tar

docker image rm -f okmindmapdb:v1
docker load -i docker/okmindmapdb.tar
docker rm -f okmindmapdb
docker run --restart=always --name okmindmapdb -dt \
    -v $(pwd)/db/mysql:/tmp/db \
    -p 3306:3306 \
    -t okmindmapdb:v1 
(sleep 10; docker exec -t okmindmapdb bash /tmp/db/auto.sh) & 

docker image rm -f okmindmap:v1
docker load -i docker/okmindmap.tar
docker rm -f okmindmap
docker run  --restart=always --name okmindmap -dt \
    -v $(pwd)/WebContent:/opt/tomcat/webapps/okmm \
    -p 8080:8080 \
    -t okmindmap:v1 

rm -rf $(pwd)/docker/okmindmap.tar
rm -rf $(pwd)/docker/okmindmapdb.tar
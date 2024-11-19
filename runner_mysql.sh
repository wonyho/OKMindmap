
#!/bin/bash
#use for Docker mode only

docker rm -f okmindmapdb
docker run --restart=always --name okmindmapdb -dt \
    -v $(pwd)/db/mysql:/tmp/db \
    -p 3306:3306 \
    -t okmindmapdb:v1 
(sleep 10; docker exec -t okmindmapdb bash /tmp/db/auto.sh) & 
    
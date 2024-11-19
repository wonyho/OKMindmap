
#!/bin/bash
#use for Docker mode only

docker rm -f okmindmap
docker run  --restart=always --name okmindmap -dt \
    -v $(pwd)/WebContent:/opt/tomcat/webapps/okmm \
    -p 8080:8080 \
    -t okmindmap:v1 
    
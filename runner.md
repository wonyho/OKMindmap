#use for Docker mode only

1. You have to install docker services on your env 

Visit url bellow to know how to install docker on your env
https://docs.docker.com/engine/install

2. Create WebContent/WEB-INF/jdbc.properties from WebContent/WEB-INF/jdbc.properties.default for Database connection
- Change localhost to your host IP
- If you have personal database server, change to your info

3. Create WebContent/WEB-INF/mail.properties from WebContent/WEB-INF/mail.properties.default 
- Change mail info to your mail server

4. Install docker services to your host

5. Run ./runner_install.sh to start Okmindmap services with default data. 

6. Login service with default account and enjoy !
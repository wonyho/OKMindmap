# OKMindmap
OKMIndmap Open Source Repository
About OKMIndmap
===================================
OKMindmap is a web-based mind map service that has been developed/serviced since 2010 and currently supports services under the name Tubestory. You can use the service at http://okmindmap.com. The creation, management, and distribution of knowledge have become important issues in modern society. In general, information can be expressed in relation to other information. Well-defined relationships are a key part of knowledge expression. Mind maps are useful tools for knowledge expression. With the advent of the 4th Industrial Revolution, 4C (Collaboration, Communication, Critical Thinking, Creativity) have become core competencies in learning and work. Easy-to-use and accessible tools are needed to collaboratively create, convert, transfer, and record knowledge. OKMindmap is a tool suitable for this purpose, adding the latest technology features to existing mind maps. People can easily collaborate on creating mind maps using text, links, images, videos, and iframes in a web browser, and these maps can be converted to other knowledge expression methods. Users can immediately use the maps they have created to make web presentations in the form of PPT or Prezi. It also provides integration with Moodle and Node-Red. Moodle is a powerful LMS that allows you to connect Moodle activities to nodes on the map. Node-RED allows you to create nodes on the map for remote switches for IoT power or sensor readings, allowing you to read remote sensors and turn on switches. Anyone who learns, teaches, researches, or runs a business can use these powerful tools to improve their performance.

Watch for more inforamtion https://example.com](https://okmindmap.org/KoreanWiki/index.php?title=OKMIndmap/Tubestory

How to set up the development environment (Eclipse)
===================================

* If you checked out from SVN, set items 2, 3, and 4.1.
* If you change the settings and commit, the settings file will be changed if someone else updates it, so
do not commit the settings files.

1. Change the text file encoding to UTF-8
1.1 Right-click on the project name and select Properties.
1.2 In the Properties window, select Resource, select "Other" in the "Text file encoding"

and select "UTF-8".

2. Set up the build environment

2.1 Copy the build.properties.default file to build.properties and modify the file

Change the appserver.home, tomcat.manager.username, tomcat.manager.password

2.1.1 How to set up tomcat-users.xml

Add manager as follows in the <tomcat-users> tag.

<role rolename="manager"/>
<role rolename="admin"/>
<user username="admin" password="1audtjs2" roles="admin,manager"/>

2.2 Ant setting

Select "Window > Show View > Ant" from the menu bar to display the Ant window.

Drag and drop the build.xml file into the Ant window.

3. Database setting

3.0 Install Mysql, install sqlyog community as a Mysql-related program.

3.1 Create user and DB (Create with the name and DB set in build.properties)

3.1 Create table

In MySQL Console, run db/mysql/create_tables.sql, create_function.sql, and load_data.sql files in order.

3.2 JDBC Setting

Copy the war/WEB-INF/jdbc.properties.default file to jdbc.properties and set it to your liking.

4. Build Path Setting

4.1 Add [Tomcat directory]/lib/servlet-api.jar and jsp-api.jar files to the build path.

4.2 Add the jar files in the war/WEB-INF/lib directory to the build path.

5. Build & Deploy

5.1 Deploy

Double-click deploy in the Ant window, and the okmindmap directory will be created in the Tomcat webapps directory and deployed there.

5.2 reload

Usually, if the jsp or js file has been changed, you only need to deploy, but to apply the compiled (java) file, you need to reload.

6. Execution

6.1 Tomcat start/stop

Double-click tomcat-start in the Ant window to start Tomcat, and double-click tomcat-stop to stop Tomcat.

6.2 Application(okmindmap) start/stop/reload

Double-click okmindmap-start, okmindmap-stop, and okmindmap-reload in the Ant window to start/stop/reload only okmindmap without restarting Tomcat.

This must be done while Tomcat is started.

6.3 Enter http://localhost:8080/okmindmap in the browser.

7. Development

7.1 Source code

Place Java source code in the src directory, and other files such as jsp, xml, and images in the war directory.

7.2 Spring Framework related environment configuration files

war/WEB-INF/applicationContext.xml => Service configuration
war/WEB-INF/mindmap-servlet.xml => Action configuration,
war/WEB-INF/dataAccessContext-local.xml => DAO configuration

7.3 iBATIS configuration files

war/WEB-INF/sql-map-config.xml => iBATIS configuration,
OR Mapping configuration xml files configuration
Can be replaced with hibernate
src/com/okmindmap/dao/ibatis/maps => OR Mapping configuration xml files location

7.4 Direct Web Remoting configuration file

war/WEB-INF/dwr.xml

7.5 URL Rewrite configuration file

war/WEB-INF/urlrewrite.xml

** Add **
1 Right-click on the project name and select Properties.
2 Select Java Build Path on the left tab. 3 Click Add Folder in the Source tab.
4 Select src and test folders and click OK.

** User **

ID: admin
Password: admin

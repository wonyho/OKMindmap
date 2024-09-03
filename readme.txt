
  개발 환경 설정 방법(Eclipse)
===================================

* SVN에서 Checkout을 한 경우 2, 3, 4.1 번 항목을 설정한다.
* 설정을 변경하고 Commit을 하게되면 다른 사람이 Update할 경우 설정파일이 변경되게 되므로
    설정 파일들은 Commit하지 않도록 한다.

	
1. 텍스트 파일 인코딩을 UTF-8로 변경
	1.1 project 이름에 오른쪽 마우스 클릭 후 Properties 선택한다.
	1.2 Properties 창에서 Resource를 선택, "Text file encoding"
	        항목에서 "Other"를 선택하고 "UTF-8"을 선택한다.
	
2. build 환경 설정

	2.1 build.properties.default 파일을 build.properties로 복사 후 파일 수정
			
		appserver.home, tomcat.manager.username, tomcat.manager.password
		설정을 자신에 맞게 변경한다.
		
		2.1.1 tomcat-users.xml 설정방법
			<tomcat-users> 태그안에 다음과 같이 manager를 추가한다.
					
			<role rolename="manager"/>
			<role rolename="admin"/>
			<user username="admin" password="1audtjs2" roles="admin,manager"/>
				
	2.2 ant 설정
	
		메뉴바에서 "Window > Show View > Ant" 선택해서 Ant 창이 보이도록 한다. 
		build.xml 파일 Ant 창에 드래그앤드롭 한다.

3. Database 설정

	3.0 Mysql 설치, Mysql 관련 프로그램으로 sqlyog community 설치 권장
	
	3.1 사용자 및 DB 생성 (build.properties에서 설정한 이름과 DB로 생성)
	
	3.1 Table 생성
	
		MySQL Console에서 db/mysql/create_tables.sql, create_function.sql, load_data.sql 파일을 차례로 실행한다.
		
	3.2 JDBC 설정

		war/WEB-INF/jdbc.properties.default 파일을 jdbc.properties 로 복사 후 자신에 맞게 설정한다.
	
4. Build Path 설정

	4.1 [Tomcat 디렉토리]/lib/servlet-api.jar 및 jsp-api.jar 파일을 build path에 추가한다.
	
	4.2 war/WEB-INF/lib 디렉토리에 있는 jar 파일을 build path에 추가한다. 
	
5. Build & Deploy

	5.1 Deploy
	
		Ant 창에서  deply 를 더블클릭하면 Tomcat의 webapps 디렉토리에 okmindmap
		디렉토리가 생기고 이곳에 deploy가 된다.
	
	5.2 reload
	
		보통 jsp, js 파일이 변경된 경우 deploy만 하면 되지만, 컴파일된 (java) 파일을 적용하기 위해서는
		reload를 해야 한다.
		

6. 실행
 
 	6.1 Tomcat start/stop
 		
 		Ant 창에서 tomcat-start를 더블클릭하면 Tomcat이 시작되고 tomcat-stop을
 		더블클릭하면 Tomcat이 정지한다.
 		
 	6.2 Application(okmindmap) start/stop/reload
 	
 		Ant 창에서 okmindmap-start, okmindmap-stop, okmindmap-reload 를
 		더블클릭하여 Tomcat을 재시작하지 않고 okmindmap 만을 시작/정지/재로드 할 수 있다.
 		Tomcat이 시작된 상태에서 해야 한다.
 		
 	6.3 브라우저에서 http://localhost:8080/okmindmap 을 입력한다.


7. 개발

	7.1 소스 코드
	
		Java 소스코드는 src 디렉토리에, 그 외에 jsp, xml, image 등의 파일들은 
		war 디렉토리에 위치 시킨다.

	7.2 Spring Framework 관련 환경 설정 파일들
	
		war/WEB-INF/applicationContext.xml			=> Service 설정
		war/WEB-INF/mindmap-servlet.xml				=> Action 설정,
		war/WEB-INF/dataAccessContext-local.xml 	=> DAO 설정
		
	7.3 iBATIS 설정 파일들
	
		war/WEB-INF/sql-map-config.xml					=> iBATIS 설정,
													 					OR Mapping 설정 xml 파일들을 설정
													   					hibernate로 교체 가능
		src/com/okmindmap/dao/ibatis/maps			=> OR Mapping 설정 xml 파일들 위치
		
	7.4 Direct Web Remoting 설정 파일
	
		war/WEB-INF/dwr.xml
		
	7.5 URL Rewrite 설정 파일
	
		war/WEB-INF/urlrewrite.xml
		

** 추가 **
	1 project 이름에 오른쪽 마우스 클릭 후 Properties 선택한다.
	2 왼쪽 탭에서 Java Build Path 선택.
	3 Source탭에서 Add Folder을 클릭.
	4 src, test 폴더 선택후 OK.

** 사용자 **

	아이디: admin
	비밀번호: admin

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale"%>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils"%>
<%@ page import="com.okmindmap.configuration.Configuration"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%
	long updateTime = 0l;
	if (Configuration.getBoolean("okmindmap.debug")) {
		updateTime = System.currentTimeMillis() / 1000;
	} else {
		updateTime = Configuration.getLong("okmindmap.update.version");
	}
%>

<c:choose>
    <c:when test="${cookie['locale'].getValue() == 'en'}">
        <c:set var="locale" value="en" />
    </c:when>
    <c:when test="${cookie['locale'].getValue() == 'es'}">
		<c:set var="locale" value="es"/>
	</c:when>
    <c:when test="${cookie['locale'].getValue() == 'vi'}">
        <c:set var="locale" value="vi" />
    </c:when>
    <c:otherwise>
        <c:set var="locale" value="ko" />
    </c:otherwise>
</c:choose>

<fmt:setLocale value="${locale}" />

<!DOCTYPE html>
<html lang="${locale}">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/theme/dist/images/favicon.png" />
    <!-- Theme -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/theme/dist/assets/css/app.css?v=<%=updateTime%>">
    <script src="${pageContext.request.contextPath}/theme/dist/assets/js/app.js?v=<%=updateTime%>"></script>
	<script src="https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"></script>
	
    <title>
        IoT support
    </title>
	<style>
	.center {
	  display: block;
	  margin-left: auto;
	  margin-right: auto;

	}
	</style>
    <script type="text/javascript">
		
    </script>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-light" style="background-color: #48b87e !important;">
  <a class="navbar-brand" href="#">OKMindmap IoT</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNavDropdown">
    <ul class="navbar-nav">
      <%-- <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}">Homepage</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="${pageContext.request.contextPath}">Overview</a>
      </li> --%>
      <li class="nav-item  active dropdown">
        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Examples
        </a>
        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
          <%-- <a class="dropdown-item" href="${pageContext.request.contextPath}/doc/iot/general.jsp">General</a> --%>
          <a class="dropdown-item" href="${pageContext.request.contextPath}/doc/iot/esp8266.jsp">ESP8266</a>
          <a class="dropdown-item" href="${pageContext.request.contextPath}/doc/iot/raspberry.jsp">Respberry Pi</a>
        </div>
      </li>
    </ul>
  </div>
</nav>
<div class="container my-4">
	<h4 class="text-secondary"><span class="badge badge-secondary">I</span> Config Arduino IDE?</h4>
	<p><b>1.</b> Open the Arduino IDE. Select <b>Files -> Preferences</b> and enter the URL below the Additional Board Manager URLs field. You can add multiple URLs (like URL1, URL2,...,URLn), separating them with commas.</p>
	<p class="ml-5">URL: http://arduino.esp8266.com/stable/package_esp8266com_index.json</p>
	<img class="center" style="height: 400px;" alt="" src="${pageContext.request.contextPath}/doc/img/img2.png">
	<p><b>2.</b> Open the <b>Boards Manager</b> from <b>Tools -> Board -> Boards Manager</b> and install the ESP8266 platform. To find the correct device, search for <b>ESP8266</b> within the search bar.</p>
	<img class="center" style="height: 400px;" alt="" src="${pageContext.request.contextPath}/doc/img/img3.png">
	<p><b>3.</b> Select the ESP8266 module you’re using. In this case, we decided to use the ESP8266MOD. To select the board, go to <b>Tools > Board</b> Select the board <b>Generic ESP8266 Module</b>.</p>
	<img class="center" style="height: 400px;" alt="" src="${pageContext.request.contextPath}/doc/img/img4.png">
	<p>Additionally, to communicate with the board, we’ll also need to select the port. Go to <b>Tools -> Port</b> and select the appropriate <b>PORT</b> for your device.</p>
	<p>To keep everything running fast and smooth, let’s make sure the upload speed is optimized to 115200. Go to <b>Tools -> Upload Speed -> 115200</b>.</p>
	
	<h4 class="text-secondary"><span class="badge badge-secondary">II</span> Wifi connection setting</h4>
	<p>Copy and paste the below code into the Arduino IDE, including your specific device and variable parameters.</p>
	<pre class="prettyprint lang-cc">
		#include "ESP8266WiFi.h"
		#include "WiFiClient.h"
		
		const char *ssid = "YOUR_WIFI_SSID";
		const char *password = "YOUR_WIFI_PASSWORD";
		unsigned long lastTime = 0;
		unsigned long timerDelay = 3000;
		
		void setup()
		{
		  Serial.begin(115200);
		
		  WiFi.begin(ssid, password);
		  Serial.println("Connecting");
		  while (WiFi.status() != WL_CONNECTED)
		  {
		    delay(500);
		    Serial.print(".");
		  }
		  Serial.println("");
		  Serial.print("Connected, IP: ");
		  Serial.println(WiFi.localIP());
		}
		
		void loop()
		{
		  if ((millis() - lastTime) > timerDelay)
		  {
		    if (WiFi.status() == WL_CONNECTED)
		    {
		      //doEvent();
		    }
		    else
		    {
		      Serial.println("WiFi Disconnected");
		    }
		    lastTime = millis();
		  }
		}
		</pre>
		<p>Serial monitor result:</p>
		<pre class="prettyprint lang-bsh">
		#Connecting
		.......
		Connected, IP: 192.168.2.132
	</pre>
	
	
	<h4 class="text-secondary"><span class="badge badge-secondary">III</span> Build IoT client with ESP8266</h4>
	<p><b>1.</b>We need download Tubestory IoT client library for ESP8266. After download, include it to your iot project to use. <a href="${pageContext.request.contextPath}/doc/iot/lib/8266/NodeRed.zip">Click here to download (version 1.1)</a></p>
	<p><b>2.</b>Open and edit functions file named <b>NodeRed.h</b> like bellow: </p>
	<pre class="prettyprint lang-cc">
		#include "helper.h"

		SocketIOClient client;
		  
		String switch01 = "";
		String sensor01 = "";
		
		// Node-RED server IP and port
		char host[] = "133.186.143.148";
		int port = 1880;
		
		void initDevice()
		{
		  switch01 = "motorctrl." + macAddr;
		  sensor01 = "dhtsensor." + macAddr;
		}
		
		// Call this function in setup() function
		// to init Node-RED service.
		
		void initNodeRed()
		{
		  EEPROM.begin(512);
		  setMacAddr(WiFi.macAddress());
		
		  // Tubestory account info
		  setUserName("YOUR_USERNAME");
		  setPassword("YOUR_PASSWORD");
		  
		  // Node-RED flow's info, 
		  // uncomment bellow and put already flow id there, 
		  // or get new flow id of this device after register. Example: flowId = "d6862d17.e92d1"; 
		  //flowId = "FLOW_ID";
		  
		  // Set name for this device
		  setDevicesName("YOUR_DEVICE_NAME");
		  
		  // NodeJs serives Info, please keep default for Tubestory
		  setNodeJsAddr("http://133.186.135.53");
		  setNodeJsPort("80");
		  
		
		  //Do Node-Red connection, please don't change all line bellow
		  if (!client.connect(host, port, ""))
		  {
		    Serial.println("connection failed");
		    return;
		  }
		  if (client.connected())
		  {
		    setSocketIO(client);
		  }
		  initDevice();
		}
		
		// This function must be defined later, where use to do action
		// getNumberResponseValue(data) => return number value of event content;
		// getStringResponseValue(data) => return string value of event content;
		
		void nodeRedListenner(String event, String data);
		
		//Example:
		//void nodeRedListenner(String event, String data){
		// Check event from Node-RED server;
		// the name of event same with name of devices is defined in NodeRed.h
		//  if(event == switch01){
		//    String action = getNumberResponseValue(data);
		//    demoSwicthButtonAction(action);
		//    Serial.println("Do event with switch 01 ");
		//  }
		
		// Upload value to Node-RED server (json);
		// demoTempSenserAction();
		//}
		
		// Call this funtion in loop() function
		// to check, update, and do all Node-RED event;
		
		void checkNodeRedConnection()
		{
		  if (client.connected())
		  {
		    //Serial.println("Socket.io connected");
		    setSocketIO(client);
		  }
		  else
		  {
		    //Serial.println("Socket.io disconnected");
		    client.connect(host, port, "");
		  }
		
		  if (client.monitor())
		  {
		    Serial.println("Socket.io event");
		    Serial.println("Ask to connect to flow: " + flowId);
		    doEvent(RID, Rname, Rcontent);
		    nodeRedListenner(RID, Rcontent);
		  }
		}
	</pre>
	<%-- <h4 class="text-secondary"><span class="badge badge-secondary">IV</span> Get device's API key and ID of device connection</h4>
	<p>To have API key, must have account at <a href="http://tubestory.co.kr">tubestory.co.kr</a>. After login, go to <b>Account setting -> IoT setting</b>, 
	if you don't have ready device, please add new first. Please look at video bellow to know how to get ID and API key string.</p>	
	<video class="center" width="" height="400" controls>
	  <source src="${pageContext.request.contextPath}/doc/img/video1.mov" type="video/mp4">
	</video> --%>
	
	<h4 class="text-secondary"><span class="badge badge-secondary">IV</span> Run the first example</h4>
	<img class="center" style="height: 400px;" alt="" src="${pageContext.request.contextPath}/doc/img/img6.png">
	<pre class="prettyprint lang-cc">
		#include "ESP8266WiFi.h"
		#include "WiFiClient.h"
		#include "NodeRed.h"
		
		#include "Hash.h"
		#include "Adafruit_Sensor.h"
		#include "DHT.h"
		
		const char *ssid = "YOUR_WIFI_SSID";
		const char *password = "YOUR_WIFI_PASSWORD";
		
		unsigned long lastTime = 0;
		unsigned long timerDelay = 500;
		
		// Assign output variables to GPIO pins
		const int output4 = 4;
		
		// Digital pin connected to the DHT sensor
		#define DHTPIN 5
		// Uncomment the type of sensor in use:
		#define DHTTYPE DHT11 // DHT 11
		//#define DHTTYPE    DHT22     // DHT 22 (AM2302)
		//#define DHTTYPE    DHT21     // DHT 21 (AM2301)
		DHT dht(DHTPIN, DHTTYPE);
		
		// current temperature & humidity, updated in loop()
		float t = 30.0;
		float h = 60.0;
		
		void setup()
		{
		
		  Serial.begin(115200);
		
		  WiFi.begin(ssid, password);
		  Serial.println("Connecting");
		  while (WiFi.status() != WL_CONNECTED)
		  {
		    delay(500);
		    Serial.print(".");
		  }
		  Serial.println("");
		  Serial.print("Connected, IP: ");
		  Serial.println(WiFi.localIP());
		  Serial.print("MAC: ");
		  Serial.println(WiFi.macAddress());
		
		  // Initialize the output variables as outputs
		  pinMode(output4, OUTPUT);
		  // Set outputs to LOW
		  digitalWrite(output4, LOW);
		  dht.begin();
		
		  if (WiFi.status() == WL_CONNECTED)
		  {
		    initNodeRed();
		  }
		}
		
		void demoSwicthButtonAction(String action)
		{
		  Serial.println(action);
		  if (action == "1")
		  {
		    digitalWrite(output4, HIGH);
		  }
		  else if (action == "0")
		  {
		    digitalWrite(output4, LOW);
		  }
		}
		
		void demoTempSenserAction()
		{
		  Serial.println("Read from DHT sensor!");
		  //Read Temp
		  float newT = dht.readTemperature();
		  if (isnan(newT))
		  {
		    Serial.println("Failed to read_T from DHT sensor!");
		  }
		  else
		  {
		    t = newT;
		    Serial.print("Temp = ");
		    Serial.println(t);
		  }
		  // Read Humidity
		  float newH = dht.readHumidity();
		  if (isnan(newH))
		  {
		    Serial.println("Failed to read_H from DHT sensor!");
		  }
		  else
		  {
		    h = newH;
		    Serial.print("Humidity = ");
		    Serial.println(h);
		  }
		  String jdata = "{\"t\":" + String((int)t) + ", \"h\":" + String(h) + "}";
		  client.sendJSON(sensor01, jdata);
		}
		
		void nodeRedListenner(String event, String data)
		{
		  // Check event from Node-RED server;
		  // the name of event same with name of devices is defined in NodeRed.h
		  if (event == switch01)
		  {
		    String action = getNumberResponseValue(data);
		    demoSwicthButtonAction(action);
		    Serial.println("Do event with switch 01 ");
		  }
		
		  // Upload value to Node-RED server (json);
		  demoTempSenserAction();
		}
		
		void loop()
		{
		  if ((millis() - lastTime) > timerDelay)
		  {
		    if (WiFi.status() == WL_CONNECTED)
		    {
		      checkNodeRedConnection();
		    }
		    else
		    {
		      Serial.println("WiFi Disconnected");
		    }
		    lastTime = millis();
		  }
		}
	</pre>

	<p>Serial monitor result:</p>
	<pre class="prettyprint lang-bsh">
		Connecting
		.......
		Connected, IP: 192.168.2.146
		MAC: 2C:F4:32:13:21:E2
		~
		Received message = 42["flow_connected","19e41c73.55e244"]
		Socket.io event
		Ask to connect to flow: 19e41c73.55e244
		Connected to flow has id: 19e41c73.55e244
		Read from DHT sensor!
		Temp = 31.30
		Humidity = 65.00
		Socket.io event
		Ask to connect to flow: 19e41c73.55e244
		Connected to flow has id: 19e41c73.55e244
		Read from DHT sensor!
		Temp = 31.30
		Humidity = 65.00
	</pre>
	<p><a href="${pageContext.request.contextPath}/doc/iot/lib/8266/NodeRED_8266.zip">Click here to download</a> full source code and library for this demo (version 1.1)</p>
	<h4 class="text-secondary"><span class="badge badge-secondary">V</span> How to use IoT node on mindmap?</h4>
	
	<video class="center" width="" height="400" controls>
	  <source src="${pageContext.request.contextPath}/doc/img/video2.mov" type="video/mp4">
	</video>
</div>


</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Test</title>
</head>

<body>

<form method="post" action="${pageContext.request.contextPath}/api/create.do">
TITLE: <input type="text" name="title" value=""/><br/>
ATC_SEQ: <input type="text" name="atc_seq" value="100"/><br/>
CC: <input type="text" name="cc" value="Y"/><br/>
<input type="submit"/>
</form>


</body>
</html>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<jsp:include page="components/head.jsp" />
<div class="d-flex justify-content-between page-tool-bar py-3 ">
	<div class="left-tool">
		<button type="button" class="btn btn-sm btn-primary"  data-bs-toggle="modal" data-bs-target="#addNew">Add API Key</button>
	</div>
	<div class="right-tool">
		<a href="${pageContext.request.contextPath}/sa/googleapi.do" class="btn btn-sm btn-warning">Refresh</a>
		<a class="btn btn-sm btn-info">${data.total_key} Rows</a>
	</div>
</div>
<table class="table table-hover table-bordered">
  <thead>
    <tr>
      <th class="text-center align-middle" scope="col" rowspan="2">#</th>
      <th class="text-center align-middle"  scope="col" rowspan="2">Google API Key</th>
      <th class="text-center align-middle"  scope="col" rowspan="2">Applied</th>
      <th class="text-center align-middle" scope="col" colspan="2">Images Search</th>
      <th class="text-center align-middle"  scope="col" colspan="2">Videos Search</th>
      <th class="text-center align-middle"  scope="col" colspan="2">Text Search</th>
      <th class="text-center align-middle"  scope="col" rowspan="2">Actions</th>
    </tr>
    <tr>
      <th class="text-center align-middle"  scope="col" >Today</th>
      <th class="text-center align-middle"  scope="col" >Total</th>
      <th class="text-center align-middle"  scope="col" >Today</th>
      <th class="text-center align-middle"  scope="col" >Total</th>
      <th class="text-center align-middle"  scope="col" >Today</th>
      <th class="text-center align-middle"  scope="col" >Total</th>
    </tr>
  </thead>
  <tbody>
  <% int i =0; %>
  <c:forEach var="key" items="${data.keys}">
   <tr>
	   	<td class="text-center align-middle"><%=++i %></td>
	   	<td class="text-center align-middle">${key.key.substring(0,20)}...</td>
	   	<td class="text-center align-middle">${key.created}</td>
	   	<td class="text-center align-middle">${key.getCounter("image")}</td>
	   	<td class="text-center align-middle">${key.getCounter("image_all")}</td>
	   	<td class="text-center align-middle">${key.getCounter("youtube")}</td>
	   	<td class="text-center align-middle">${key.getCounter("youtube_all")}</td>
	   	<td class="text-center align-middle">${key.getCounter("text")}</td>
	   	<td class="text-center align-middle">${key.getCounter("text_all")}</td>
	   	<td class="text-center align-middle"><a href="${pageContext.request.contextPath}/sa/googleapi.do?action=del&api_key=${key.key}" class="btn btn-sm btn-danger text-white">Remove</a></td>
   </tr>
    </c:forEach>
  </tbody>
</table>
<div class="d-flex justify-content-between page-tool-bar py-3 ">
	<div class="left-tool">
		<button type="button" class="btn btn-sm btn-primary"  data-bs-toggle="modal" data-bs-target="#addNew">Add API Key</button>
	</div>
	<div class="right-tool">
		<a href="${pageContext.request.contextPath}/sa/googleapi.do" class="btn btn-sm btn-warning">Refresh</a>
		<a class="btn btn-sm btn-info">${data.total_key} Rows</a>
	</div>
</div>

<div class="modal fade" id="addNew" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="addNewLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addNewLabel">Add Google API Key</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="${pageContext.request.contextPath}/sa/googleapi.do" method="post">
	      <div class="modal-body">
	        <input class="form-control" name="api_key" type="text" placeholder="Google API key : AIzaSyA5j1VZ3hJccqvMQZ8h_nWAl5kzRMZNnUQ" aria-label="Google API key">
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
	        <button type="submit" class="btn btn-primary">Submit</button>
	      </div>
      </form>
    </div>
  </div>
</div>
<jsp:include page="components/foot.jsp" />
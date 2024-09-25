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
		<a href="${pageContext.request.contextPath}/sa/translateapi.do" class="btn btn-sm btn-warning">Refresh</a>
		<a class="btn btn-sm btn-info">${data.total_key} Rows</a>
	</div>
</div>
<table class="table table-hover table-bordered">
  <thead>
    <tr>
      <th class="text-center align-middle" scope="col">#</th>
      <th class="text-center align-middle"  scope="col">Translate API Key</th>
      <th class="text-center align-middle"  scope="col">Applied</th>
      <th class="text-center align-middle" scope="col">Today</th>
      <th class="text-center align-middle"  scope="col">This month</th>
      <th class="text-center align-middle"  scope="col">This year</th>
      <th class="text-center align-middle"  scope="col">Total</th>
    </tr>
  </thead>
  <tbody>
  <% int i =0; %>
  <c:forEach var="key" items="${data.keys}">
   <tr>
	   	<td class="text-center align-middle"><%=++i %></td>
	   	<td class="text-center align-middle">${key.key.substring(0,20)}...</td>
	   	<td class="text-center align-middle">${key.created}</td>
	   	<td class="text-center align-middle">${key.getCounter("day")}</td>
	   	<td class="text-center align-middle">${key.getCounter("month")}</td>
	   	<td class="text-center align-middle">${key.getCounter("year")}</td>
	   	<td class="text-center align-middle">${key.getCounter("total")}</td>
	   	<td class="text-center align-middle"><a href="${pageContext.request.contextPath}/sa/translateapi.do?action=del&api_key=${key.key}" class="btn btn-sm btn-danger text-white">Remove</a></td>
   </tr>
    </c:forEach>
  </tbody>
</table>
<div class="d-flex justify-content-between page-tool-bar py-3 ">
	<div class="left-tool">
		<button type="button" class="btn btn-sm btn-primary"  data-bs-toggle="modal" data-bs-target="#addNew">Add API Key</button>
	</div>
	<div class="right-tool">
		<a href="${pageContext.request.contextPath}/sa/translateapi.do" class="btn btn-sm btn-warning">Refresh</a>
		<a class="btn btn-sm btn-info">${data.total_key} Rows</a>
	</div>
</div>

<div class="modal fade" id="addNew" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="addNewLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addNewLabel">Add Translate API Key</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="${pageContext.request.contextPath}/sa/translateapi.do" method="post">
	      <div class="modal-body">
	        <input class="form-control" name="api_key" type="text" placeholder="Translate API key : AIzaSyA5j1VZ3hJccqvMQZ8h_nWAl5kzRMZNnUQ" aria-label="Translate API key">
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
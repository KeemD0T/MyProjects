<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/Art.css">



<meta charset="UTF-8">
<title>Movie Checkout System</title>
</head>
<body>
	<div class="container">
		<h2>Movie Checkout System</h2>

		<br>
		<div class="button-container">
			<a class="action-button" href="${pageContext.request.contextPath}/">Home</a>

		</div>
		<br>

		<table>

			<tr>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Email</th>
				<th>Actions</th>
			</tr>

			<c:forEach var="eachCustomer" items="${customers}">

				<c:url var="historyLink" value="/movie/history">
					<c:param name="customerId" value="${eachCustomer.id}" />
				</c:url>

				<tr>

					<td>${eachCustomer.firstName}</td>
					<td>${eachCustomer.lastName}</td>
					<td>${eachCustomer.email}</td>

					<td><a class="small-button" href="${historyLink}">
							Checkout History </a></td>

				</tr>

			</c:forEach>

		</table>

		<br>
		<br>

		<form
			action="${pageContext.request.contextPath}/movie/showCustomerFormForAdd"
			method="get">
			<input class="action-button" type="submit" value="Add New Customer" />
		</form>

		<br> <a class="action-button"
			href="${pageContext.request.contextPath}/movie/list"> Go To Movie
			List </a>
	</div>
</body>
</html>
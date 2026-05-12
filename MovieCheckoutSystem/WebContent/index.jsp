
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

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


		<h1>Movie Checkout System</h1>


		<div class="button-container">

			<a class="action-button"
				href="${pageContext.request.contextPath}/movie/list"> Browse
				Movies </a> <a class="action-button"
				href="${pageContext.request.contextPath}/movie/customers"> View
				Customers </a> <a class="action-button"
				href="${pageContext.request.contextPath}/movie/showFormForAdd">
				Add Movie </a>

		</div>

		<div class="api-section">

			<h2>REST API</h2>

			<div class="api-links">

				<a href="${pageContext.request.contextPath}/api/movies"> Get All
					Movies </a> <a href="${pageContext.request.contextPath}/api/customers">
					Get All Customers </a> <a
					href="${pageContext.request.contextPath}/api/checkouts"> Get
					All Checkouts </a>

			</div>

		</div>

		<div class="footer">CPS 278 Final Project • Movie Checkout
			System</div>

	</div>

</body>
</html>


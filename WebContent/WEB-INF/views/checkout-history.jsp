<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
href="${pageContext.request.contextPath}/resources/css/Art.css">

<meta charset="UTF-8">
<title>Checkout History</title>
</head>
<body>
<div class="container">

<div class="button-container">
    <a class="action-button" href="${pageContext.request.contextPath}/">Home</a>
    
</div>

<br>

<h2>Checkout History for ${customer.firstName} ${customer.lastName}</h2>

<table >
    <tr>
        <th>Checkout ID</th>
        <th>Movie Title</th>
        <th>Checkout Date</th>
        <th>Return Date</th>
        <th>Returned?</th>
        <th>Action</th>
    </tr>

    <c:forEach var="checkout" items="${checkouts}">
        <tr>
            <td>${checkout.id}</td>
            <td>${checkout.movie.title}</td>
            <td>${checkout.checkoutDate}</td>
            <td>${checkout.returnDate}</td>
            <td>${checkout.returned}</td>
            <td>
                <c:if test="${checkout.returned == false}">
                    <form action="${pageContext.request.contextPath}/movie/return" method="post">
                        <input class="action-button"type="hidden" name="checkoutId" value="${checkout.id}" />
                        <input class="action-button" type="submit" value="Return Movie" />
                    </form>
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>

<br>

<a class="action-button" href="${pageContext.request.contextPath}/movie/list">Back to Movie List</a>
</div>
</body>
</html>
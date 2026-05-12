<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
href="${pageContext.request.contextPath}/resources/css/Art.css">


<meta charset="UTF-8">
<title>Movie List</title>
</head>
<body>
<div class="container">


<h2>Movie Checkout System</h2>

<div class="button-container">
    <a class="action-button" href="${pageContext.request.contextPath}/">Home</a>
  
</div>


<form action="${pageContext.request.contextPath}/movie/search" method="get">
    Search:
    <input type="text" name="keyword" value="${keyword}" />
    <input class="small-button" type="submit" value="Search" />
</form>

<br>

<a href="${pageContext.request.contextPath}/movie/showFormForAdd">
    Add New Movie
</a>

<br><br>

<table >
    <tr>
        <th>Title</th>
        <th>Description</th>
        <th>Total Copies</th>
        <th>Available Copies</th>
        <th>Checkout</th>
    </tr>

    <c:forEach var="movie" items="${movies}">
        <tr>
            <td>${movie.title}</td>
            <td>${movie.description}</td>
            <td>${movie.totalCopies}</td>
            <td>${movie.availableCopies}</td>

            <td>
                <c:choose>
                    <c:when test="${movie.availableCopies > 0}">
                        <form action="${pageContext.request.contextPath}/movie/checkout" method="post">
                            <input type="hidden" name="movieId" value="${movie.id}" />

                            Customer:
                            <select name="customerId">
                                <c:forEach var="customer" items="${customers}">
                                    <option value="${customer.id}">
                                        ${customer.firstName} ${customer.lastName}
                                    </option>
                                </c:forEach>
                            </select>

                            <input class="small-button" type="submit" value="Checkout" />
                        </form>
                    </c:when>

                    <c:otherwise>
                        No copies available
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
</table>

<br>

<a  class="action-button" href="${pageContext.request.contextPath}/movie/customers">
    View Customers
</a>
</div>
</body>
</html>
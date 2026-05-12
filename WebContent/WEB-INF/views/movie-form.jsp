<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
href="${pageContext.request.contextPath}/resources/css/Art.css">


<meta charset="UTF-8">
<title>Movie Form</title>
</head>
<body>
<div class="container">

<div class="button-container">
    <a class="action-button" href="${pageContext.request.contextPath}/">Home</a>
    
</div>

<h2>Add / Update Movie</h2>

<form:form action="${pageContext.request.contextPath}/movie/saveMovie"
           modelAttribute="movie"
           method="post">

    <form:hidden path="id" />

    <table>
        <tr>
            <td>Title:</td>
            <td><form:input path="title" /></td>
        </tr>

        <tr>
            <td>Description:</td>
            <td><form:textarea path="description" rows="4" cols="40" /></td>
        </tr>

        <tr>
            <td>Total Copies:</td>
            <td><form:input path="totalCopies" /></td>
        </tr>

        <tr>
            <td>Available Copies:</td>
            <td><form:input path="availableCopies" /></td>
        </tr>

        <tr>
            <td></td>
            <td><input class="action-button" type= "submit" value="Save Movie" /></td>
        </tr>
    </table>

</form:form>

<br>

<a  class="action-button" href="${pageContext.request.contextPath}/movie/list">Back to Movie List</a>
</div>

</body>

</html>
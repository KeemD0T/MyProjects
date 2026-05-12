<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="form"
    uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
href="${pageContext.request.contextPath}/resources/css/Art.css">


<meta charset="UTF-8">
<title>Customer Form</title>
</head>
<body>
<div class="container">
<h2>Add / Update Customer</h2>
<div class="button-container">
    <a class="action-button" href="${pageContext.request.contextPath}/">Home</a>
    
</div>

<br>

<form:form
    action="${pageContext.request.contextPath}/movie/saveCustomer"
    modelAttribute="customer"
    method="post">

    <form:hidden path="id"/>

    <table>

        <tr>
            <td>First Name:</td>
            <td><form:input path="firstName"/></td>
        </tr>

        <tr>
            <td>Last Name:</td>
            <td><form:input path="lastName"/></td>
        </tr>

        <tr>
            <td>Email:</td>
            <td><form:input path="email"/></td>
        </tr>

        <tr>
            <td></td>
            <td>
                <input class="action-button" type="submit" value="Save Customer"/>
            </td>
        </tr>

    </table>

</form:form>

<br>

<a class="action-button" href="${pageContext.request.contextPath}/movie/list">
    Back to Movie List
</a>
</div>
</body>
</html>
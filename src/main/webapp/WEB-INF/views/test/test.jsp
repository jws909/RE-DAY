<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:forEach var="testMember" items="${testMemberList}">
		<p>${testMember.id}</p>
		<p>${testMember.name}</p>
		<p>${testMember.email}</p>
		<p>${testMember.regDate}</p>
		<br>
	</c:forEach>
</body>
</html>
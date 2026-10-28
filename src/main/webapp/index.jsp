<%-- index.jsp — entry point; immediately redirects to the dashboard --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.sendRedirect(request.getContextPath() + "/dashboard");
%>

<%@ page extends="com.techempower.gemini.admin.BasicAdminScratchJsp"
%><%@ include file="../include-standard-variables.jsp" %><%

// This header provides access to the following variables:
// context - The request context.
// app - The Gemini application.
// cache - The cache controller.
// inf - The application Infrastructure.

// Insert your custom code below.
// --------------------------------------------------------

%>
<%= app.getVersion().getVersionString() %>
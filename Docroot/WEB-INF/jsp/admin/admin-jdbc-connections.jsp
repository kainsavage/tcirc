<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-jdbc.jsp
// List JDBC connection profiles
//
// ----------------------------------------------------------------------

Iterator iter = (Iterator)context.getDelivery("Profiles");

vars.title = getTitle("JDBC Connection Profiles");

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>JDBC Connection Profiles</h2>

<ul>
<%
while (iter.hasNext())
{
  %><li><%= iter.next() %></li><%
}
%>
</ul>

<%@ include file="include-custom-page-footer.jsp" %>

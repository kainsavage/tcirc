<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-obj-list.jsp
// List arbitrary objects
//
// ----------------------------------------------------------------------

String className = context.getStringDelivery("ClassName");
int id = context.getIntDelivery("ID");
boolean success = context.getBooleanDelivery("Success");

String title = "Reset " + className + " instance " + id;
vars.title = getTitle(title);

nav.add(new SimpleLink("Cache List", context.getCmdURL("admin-cache-list")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2><%= title %></h2>

<% if (success) { %><p>Successfully reset instance <%= id %> of <%= className %>.</p><% }
else { %><p>Unable to reset instance <%= id %> of <%= className %>.  The class may not provide an object query format and comparator.</p><%
} %>

<%@ include file="include-custom-page-footer.jsp" %>

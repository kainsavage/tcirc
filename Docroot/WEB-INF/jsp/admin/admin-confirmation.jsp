<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-confirmation.jsp
// Confirm a user action
//
// ----------------------------------------------------------------------

message = context.getStringDelivery("Message");
String aux = context.getStringDelivery("AuxMessage");
int severity = context.getIntDelivery("Severity");
String confirm = context.getStringDelivery("Confirm");

vars.title = getTitle("Confirm " + message);

%><%@ include file="include-custom-page-header.jsp" %>

<table width="100%"><tr><td align="center">
<div class="admconfirm<%= severity %>">
  <div id="banner">Confirmation Required</div>
  <div id="action"><%= message %></div>
  <% if (StringHelper.isNonEmpty(aux)) { %><div id="auxmessage"><%= aux %></div><% } %>
  <div id="desc">
    The action you have requested requires your active confirmation.  Please click the link below the confirm your request to <%= message %>.
  </div>
  <div id="link"><a href="<%= confirm %>">Confirm Action</a></div>
</div>
</td></tr></table>

<%@ include file="include-custom-page-footer.jsp" %>

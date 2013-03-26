<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-information.jsp
// Provide information to the administrative user
//
// ----------------------------------------------------------------------

message = context.getStringDelivery("Message");
int severity = context.getIntDelivery("Severity");
String supplemental = context.getDelivery("Supplemental");

vars.title = getTitle("Information");

%><%@ include file="include-custom-page-header.jsp" %>

<table width="100%"><tr><td align="center">
<div class="admconfirm<%= severity %>">
  <div id="banner">Note</div>
  <div id="desc">
    <%= message %>
  </div>
  <div id="link"><a href="<%= context.getCmdURL(BasicAdminHandler.CMD_MENU) %>">Administration Menu</a></div>
</div>
</td></tr></table>

<% if (supplemental != null) { %>
<p>Supplemental detail:<br/>
<textarea class="largedetails"><%= render(supplemental) %></textarea>
</p>
<% } %>

<%@ include file="include-custom-page-footer.jsp" %>

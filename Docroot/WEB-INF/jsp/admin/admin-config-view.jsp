<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-config-view.jsp
// View running configuration.
//
// ----------------------------------------------------------------------

List<String> keys = (List<String>)context.getDelivery("keys");
List<String> values = (List<String>)context.getDelivery("values");

Iterator<String> keyIter = keys.iterator();
Iterator<String> valueIter = values.iterator();

vars.title = getTitle("Running configuration");

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Running Configuration</h2>

<table border="0" cellpadding="0" cellspacing="0">
<%
while (keyIter.hasNext())
{
%><tr>
  <td class="admconfitem"><%= render(keyIter.next()) %></td>
  <td class="admconfvalue"><%= render(valueIter.next()) %></td>
</tr>
<%
} 
%></table>

<%@ include file="include-custom-page-footer.jsp" %>

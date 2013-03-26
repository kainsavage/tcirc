<%@ page extends="net.teamclerks.tcirc.TCJsp" %><%@ include file="/WEB-INF/jsp/include-variables.jsp" %><%

  // -----------------------------------------------------------------
  // Home page
  //
  // author: kain
  // -----------------------------------------------------------------

  vars.title = "TCIRC Home";

Form form = context.getDelivery("form");
FormElement channel = form.getElement("channel");
FormElement server = form.getElement("server");
FormElement name = form.getElement("name");
FormElement submit = form.getElement("submit"); 
  
%><%@ include file="/WEB-INF/jsp/include-page-start.jsp" %>

<h2>TCIRC</h2>

<p>
<%= form.renderStartWithHiddenElements() %>
<table>
<tr>
	<td><%= name.renderLabel() %></td>
	<td><%= name %></td>
</tr><tr>
	<td><%= server.renderLabel() %></td>
	<td><%= server %></td>
</tr><tr>
	<td><%= channel.renderLabel() %></td>
	<td><%= channel %></td>
</tr>
<tr>
  <td colspan="2"><%= submit %></td>
</tr>
</table>
<%= form.renderEnd() %>

</p>

<%@ include file="/WEB-INF/jsp/include-page-end.jsp" %>
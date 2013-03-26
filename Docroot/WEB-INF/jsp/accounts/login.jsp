<%@ page extends="net.teamclerks.tcirc.TCJsp" %><%@ include file="/WEB-INF/jsp/include-variables.jsp" %><%

  // -----------------------------------------------------------------
  // Login page
  //
  // author: kain
  // -----------------------------------------------------------------
  
  Form form = (Form)context.getDelivery("Form");
  FormValidation formValidation = (FormValidation)context.getDelivery("FormValidation");
  String message = context.getStringDelivery("Message");
  boolean indirect = context.getBooleanDelivery("Indirect");

  vars.title = "TCIRC Login";
  
%><%@ include file="/WEB-INF/jsp/include-page-start.jsp" %>

<%= form.renderStartWithHiddenElements("form") %>

<% if (indirect) { %>
<img src="<%= renderImagePath(context, "alert.gif") %>" />
<p>The page you have requested requires that you first authenticate with TCIRC.  Please login below.</p>
<% } %>

<h2>Login</h2>

<% if (formValidation != null) { %>
<ul>
<%
Iterator iter = formValidation.getInstructionIterator();
while (iter.hasNext()) { %>
  <li><%= iter.next() %></li>
<% } %>
</ul>
<% } %>

<% if (message != null) { %>
<p><%= message %></p>
<% } %>

<div class="loginform">
<label>User&nbsp;name:</label>
<%= form.getElement("lhuser").render("width: 250px;") %><br />

<label>Password:</label>
<%= form.getElement("lhpass").render("width: 250px;") %><br />

<label></label>
<%= form.getElement("lhlogin").render("width: 100px;") %><br />

<label>Remember me:</label>
<%= form.getElement("lhremember") %><br />

<label>I forgot my password:</label>
<%= form.getElement("lhforgot") %><br /></td>
</div>

<%= form.renderEnd() %>

<%@ include file="/WEB-INF/jsp/include-page-end.jsp" %>
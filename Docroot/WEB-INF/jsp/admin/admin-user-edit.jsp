<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-user-edit.jsp
// Edit user
//
// ----------------------------------------------------------------------

Form form = (Form)context.getDelivery(GeminiConstants.GEMINI_FORM);
FormValidation validation = (FormValidation)context.getDelivery(GeminiConstants.GEMINI_FORM_VALIDATION);

vars.title = getTitle("User Edit");

onload = "document.forms['EditUserForm'].newun.focus();";

nav.add(new SimpleLink("User List", context.getCmdURL("admin-user-list")));

%><%@ include file="include-custom-page-header.jsp" %>

<h2>User Edit</h2>

<%@ include file="include-validation-bulleted.jsp" %>

<%= form.renderStartWithHiddenElements() %>

<div class="admform">
<label>Username</label><%= form.getElement("newun").render("width: 200px") %><br />
<label>Password</label><%= form.getElement("newpw").render("width: 200px") %><br />
<label>Enabled</label><%= form.getElement("enabled") %><br />
<label>Email Address</label><%= form.getElement("newem").render("width: 200px") %><br />
<label>First Name</label><%= form.getElement("first").render("width: 200px") %><br />
<label>Last Name</label><%= form.getElement("last").render("width: 200px") %><br />
<label>Last Login</label><%= form.getElement("lastlogin").render("width: 200px") %><br />
<%@ include file="include-custom-user-edit.jsp" %>
<label>&nbsp;</label><%= form.getElement("save") %><br />
</div>

<%= form.renderEnd() %>

<%@ include file="include-custom-page-footer.jsp" %>

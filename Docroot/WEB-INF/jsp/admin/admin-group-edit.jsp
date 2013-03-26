<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-group-edit.jsp
// Create/Edit user group
//
// ----------------------------------------------------------------------

Form form = (Form)context.getDelivery(GeminiConstants.GEMINI_FORM);
FormValidation validation = (FormValidation)context.getDelivery(GeminiConstants.GEMINI_FORM_VALIDATION);

vars.title = getTitle("User Group");

onload = "document.forms['groupedit'].name.focus();";

nav.add(new SimpleLink("Groups List", context.getCmdURL("admin-group-list")));

%><%@ include file="include-custom-page-header.jsp" %>

<h2>User Group</h2>

<%@ include file="include-validation-bulleted.jsp" %>

<%= form.renderStartWithHiddenElements() %>

<div class="admform">
<label>Name</label><%= form.getElement("name").render("width: 400px") %><br />
<label>Description</label><%= form.getElement("description").render("width: 400px") %><br />
<label>&nbsp;</label><%= form.getElement("save") %><br />
</div>

<%= form.renderEnd() %>

<%@ include file="include-custom-page-footer.jsp" %>

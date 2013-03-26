<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-maintenance.jsp
// Configure/edit the maintenance settings
//
// ----------------------------------------------------------------------

Form form = (Form)context.getDelivery(GeminiConstants.GEMINI_FORM);
FormValidation validation = (FormValidation)context.getDelivery(GeminiConstants.GEMINI_FORM_VALIDATION);

vars.title = getTitle("Configure Maintenance");

%><%@ include file="include-custom-page-header.jsp" %>

<h2>System Maintenance Message Configuration</h2>

<%@ include file="include-validation-bulleted.jsp" %>

<%= form.renderStartWithHiddenElements() %>

<div class="admform">
<label>Request-processing mode</label><%= form.getElement("mode") %><br />
<label>Maintenance Message</label><%= form.getElement("message").render("width: 400px") %><br />
<label>&nbsp;</label><%= form.getElement("apply") %><br />
</div>

<%= form.renderEnd() %>

<%@ include file="include-custom-page-footer.jsp" %>

<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-user-list.jsp
// List users
//
// ----------------------------------------------------------------------

Form form = (Form)context.getDelivery(GeminiConstants.GEMINI_FORM);
FormValidation validation = (FormValidation)context.getDelivery(GeminiConstants.GEMINI_FORM_VALIDATION);

int unfilteredCount = context.getIntDelivery("UserCountUnfiltered");
int filteredCount = context.getIntDelivery("UserCountFiltered");

vars.title = getTitle("User List");

String edit = context.getCmdURL("admin-user-edit");
String groups = context.getCmdURL("admin-group-membership-edit");

Collection users = (Collection)context.getDelivery("Users");

BasicWebUser user;
String username;
String email;
String firstname;
String lastname;

TabularColumn[] columns = (TabularColumn[])context.getDelivery("CustomColumns");
BasicAdminPaging paging = (BasicAdminPaging)context.getDelivery("Paging");
Iterator iter = users.iterator();

vars.onload = "document.forms['userlist'].username.focus();";

nav.add(new SimpleLink("User List", context.getCmdURL("admin-user-list")));
nav.add(new SimpleLink("CSV Export", context.getCmdURL("admin-user-list&format=csv")));
nav.add(new SimpleLink("Create New", context.getCmdURL("admin-user-edit")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-validation-bulleted.jsp" %>

<h2>User List</h2>

<%= form.renderStartWithHiddenElements() %>

<div class="admformv">
<ol>
<li><%= form.getElement("username").render("width: 150px") %><label>Username</label></li>
<li><%= form.getElement("email").render("width: 150px") %><label>Email Address</label></li>
<li><%= form.getElement("firstname").render("width: 150px") %><label>First Name</label></li>
<li><%= form.getElement("lastname").render("width: 150px") %><label>Last Name</label></li>
<li><div class="cell"><%= form.getElement("disabled") %></div><label>Include disabled</label></li>
<li><%= form.getElement("filter") %></li>
</ol>
<div class="clear"></div>
</div>

<%= form.renderEnd() %>

<% if (users.size() > 0) { %>
<%= paging.render(context) %>
<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td>Username</td>
  <td>Groups</td>
  <td>Email</td>
  <td>First name</td>
  <td>Last name</td>
<% for (int i = 0; i < columns.length; i++) { %>
  <td><%= columns[i].getDisplayName() %></td>
<% } %>
</tr>
<%
while (iter.hasNext())
{
  user = (BasicWebUser)iter.next();
  username = NetworkHelper.escapeStringForHtml(StringHelper.emptyDefault(user.getUserUsername(), "--"));
  email = NetworkHelper.escapeStringForHtml(StringHelper.emptyDefault(user.getUserEmail(), "--"));
  firstname = NetworkHelper.escapeStringForHtml(StringHelper.emptyDefault(user.getUserFirstname(), "--"));
  lastname = NetworkHelper.escapeStringForHtml(StringHelper.emptyDefault(user.getUserLastname(), "--"));
%>
<tr>
<% if (user.getId() > 0) { %>
  <td class="admconfitem"><a href="<%= edit %>&id=<%= user.getId() %>"><%= username %></a></td>
  <td class="admconfvalue"><a href="<%= groups %>&id=<%= user.getId() %>">Groups</a></td>
<% } else { %>
  <td class="admconfitem"><%= username %></td>
  <td class="admconfvalue">--</td>
<% } %>
  <td class="admconfvalue"><%= email %></td>
  <td class="admconfvalue"><%= firstname %></td>
  <td class="admconfvalue"><%= lastname %></td>
<% for (int i = 0; i < columns.length; i++) { %>
  <td class="admconfvalue"><%-- Note that it's not necessary to escape the following value with render() because it is typically processed internally by CompositeReflectiveColumn. --%><%= columns[i].getValue(user) %></td>
<% } %>
</tr>
<% } %>
</table>
<%= paging.render(context) %>
<% } %>

<p><%= (filteredCount == unfilteredCount ? "All " : "") %><%= filteredCount %> <%= StringHelper.pluralize(filteredCount, "user matches", "users match") %> the specified filters; <%= unfilteredCount %> user<%= StringHelper.pluralize(unfilteredCount) %> total.</p>

<%@ include file="include-custom-page-footer.jsp" %>

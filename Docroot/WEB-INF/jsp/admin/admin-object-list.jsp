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
String viewUrl = context.getCmdURL("admin-object-view&cid=" + className);
String updateUrl = context.getCmdURL("admin-object-update&cid=" + className);
BasicAdminPaging paging = (BasicAdminPaging)context.getDelivery("Paging");
List objects = (List)context.getDelivery("Objects");
Iterator iter = objects.iterator();
Identifiable obj;
Form form = (Form)context.getDelivery("Form");

vars.title = getTitle("List " + className);

nav.add(new SimpleLink("Cache List", context.getCmdURL("admin-cache-list")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>List <%= className %></h2>

<%= form.renderStartWithHiddenElements() %>

<div class="admformv">
<ol>
<li><%= form.getElement("m").render("width: 250px") %><label>Method</label></li>
<li><%= form.getElement("v").render("width: 150px") %><label>Value to Match</label></li>
<li><%= form.getElement("filter") %></li>
</ol>
<div class="clear"></div>
</div>

<%= form.renderEnd() %>

<% if (objects.size() > 0) { %>
<%= paging.render(context) %>
<table class="attributes" border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
<td>Identity</td><td>Synopsis</td><td>Update</td><td>View</td>
</tr>
<%
while (iter.hasNext())
{
  obj = (Identifiable)iter.next();
  %><tr><td class="admconfitem"><%= obj.getId() %></td><td class="admconfvalue"><%= obj.toString() %></a></td><td class="admconfvalue"><a href="<%= updateUrl %>&id=<%= obj.getId() %>">Update</a></td><td class="admconfvalue"><a href="<%= viewUrl %>&id=<%= obj.getId() %>">View</a></td></tr><%
}
%>
</table>
<%= paging.render(context) %>
<% } else { %>
<p>No objects.</p>
<% } %>
<%@ include file="include-custom-page-footer.jsp" %>

<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-cache-list.jsp
// List cache groups
//
// ----------------------------------------------------------------------

Collection groups = (Collection)context.getDelivery("Groups");

message = context.getStringDelivery("Message");
String reset = context.getCmdURL("admin-cache-reset");
String list = context.getCmdURL("admin-object-list");

vars.title = getTitle("List Cache Groups");

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Cache Maintenance</h2>

<ul>
  <li><a title="Reset all" href="<%= reset %>">Reset all caches</a></li>
</ul>

<h2>Cache Groups</h2>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td>Class</td>
  <td align="right">Count</td>
  <td align="right">Actions</td>
</tr>

<%
Iterator iter = groups.iterator();
while (iter.hasNext())
{
  EntityGroup group = (EntityGroup)iter.next();
  %><tr>
  <td class="admconfitem"><%= group.getType().getCanonicalName() %></td>
  <td class="admconfvalue" align="right"><%= group.getSize() %> objects</td>
  <td class="admconfvalue" align="right">
    <a title="List objects" href="<%= list %>&cid=<%= group.getType().getCanonicalName() %>">List</a>
    <a title="Reset this cache" href="<%= reset %>&cid=<%= group.getType().getCanonicalName() %>">Reset</a>
  </td>
  </tr><%
}
%>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-group-list.jsp
// List user groups
//
// ----------------------------------------------------------------------

Collection groups = (Collection)context.getDelivery("Groups");

String edit = context.getCmdURL("admin-group-edit");

vars.title = getTitle("List User Groups");

nav.add(new SimpleLink("Add New Group", edit));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>User Groups</h2>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td align="right">ID</td>
  <td>Name</td>
  <td>Type</td>
  <td align="right">Actions</td>
</tr>

<%
Iterator iter = groups.iterator();
while (iter.hasNext())
{
  PyxisUserGroup group = (PyxisUserGroup)iter.next();
  if ( (group.getType() == PyxisUserGroup.TYPE_BUILTIN)
    || (group.getType() == PyxisUserGroup.TYPE_APPLICATION)
    )
  {
    %><tr>
  <td class="admconfitem" align="right"><%= group.getGroupID() %></td>
  <td class="admconfvalue"><abbr title="<%= group.getDescription() %>"><%= group.getName() %></abbr></td>
  <td class="admconfvalue">Standard</td>
  <td class="admconfvalue">&nbsp;</td>
  </tr><%
  }
  else
  {
    %><tr>
  <td class="admconfitem" align="right"><%= group.getGroupID() %></td>
  <td class="admconfvalue"><abbr title="<%= group.getDescription() %>"><%= group.getName() %></abbr></td>
  <td class="admconfvalue">Ad-hoc</td>
  <td class="admconfvalue" align="right"><a title="Edit this group" href="<%= edit %>&id=<%= group.getGroupID() %>">Edit</a></td>
  </tr><%
  }
}
%>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

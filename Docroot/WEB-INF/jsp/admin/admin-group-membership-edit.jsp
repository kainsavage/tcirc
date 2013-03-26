<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-edit-group-membership.jsp
// Edit user group membership assignments.
//
// ----------------------------------------------------------------------

BasicUser entity = (BasicUser)context.getDelivery("User");
Collection groups = (Collection)context.getDelivery("Groups");
int[] membership = (int[])context.getDelivery("Membership");

String edit = context.getCmdURL("admin-group-membership-edit&id=" + entity.getUserID() + "&" + context.getStringDelivery("Nonce"));

vars.title = getTitle("Edit Group Membership for " + entity.getUserUsername());

%><%@ include file="include-custom-page-header.jsp" %>

<h2><%= render(entity.getUserFullname()) %> (<%= render(entity.getUserUsername()) %>) is a member of:</h2>

<ul>
<%
Iterator iter = groups.iterator();
boolean groupRendered = false;
while (iter.hasNext())
{
  PyxisUserGroup group = (PyxisUserGroup)iter.next();
  if (CollectionHelper.arrayContains(membership, group.getGroupID()))
  {
    %><li><a title="<%= group.getDescription() %>" href="<%= edit %>&remove=<%= group.getGroupID() %>"><%= group.getName() %></a> (group #<%= group.getGroupID() %>)</li><%
    groupRendered = true;
  }
}
if (!groupRendered)
{
  %><li>(none)</li><%
}
%>
</ul>

<h2>Available groups:</h2>

<ul>
<%
iter = groups.iterator();
groupRendered = false;
while (iter.hasNext())
{
  PyxisUserGroup group = (PyxisUserGroup)iter.next();
  if (!CollectionHelper.arrayContains(membership, group.getGroupID()))
  {
    %><li><a title="<%= group.getDescription() %>" href="<%= edit %>&add=<%= group.getGroupID() %>"><%= group.getName() %></a> (group #<%= group.getGroupID() %>)</li><%
    groupRendered = true;
  }
}
if (!groupRendered)
{
  %><li>(none)</li><%
}
%>
</ul>
<%@ include file="include-custom-page-footer.jsp" %>

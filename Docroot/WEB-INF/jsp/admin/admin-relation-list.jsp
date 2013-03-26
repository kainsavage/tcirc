<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-relation-list.jsp
// List relations
//
// ----------------------------------------------------------------------

@SuppressWarnings("unchecked")
List<CachedRelation<?, ?>> relations = (List<CachedRelation<?, ?>>)context.getDelivery("relations");
BasicAdminPaging paging = (BasicAdminPaging)context.getDelivery("paging");
message = context.getStringDelivery("Message");

vars.title = getTitle("Relation List");
nav.add(new SimpleLink("Relation List", context.getCmdURL("admin-relation-list")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Relation List</h2>

<%= paging.render(context) %>

<table border="0" cellpadding="0" cellspacing="0">
  <tr class="admheader">
    <td>Table Name</td>
    <td>Left Class</td>
    <td>Right Class</td>
    <td align="right">Actions</td>
  </tr>
  <% for (CachedRelation<?, ?> relation : relations) { %>
  <tr>
    <td class="admconfitem">
      <%= NetworkHelper.escapeStringForHtml(relation.tableName()) %>
    </td>
    <td class="admconfitem">
      <a href="<%= NetworkHelper.escapeStringForHtml(
          context.getCmdURL(
              "admin-object-list",
              new String[] { "cid" },
              new String[] { relation.leftType().getName() }))
         %>"><%= NetworkHelper.escapeStringForHtml(
                  relation.leftType().getSimpleName()) %></a>
    </td>
    <td class="admconfitem">
      <a href="<%= NetworkHelper.escapeStringForHtml(
          context.getCmdURL(
              "admin-object-list",
              new String[] { "cid" },
              new String[] { relation.rightType().getName() }))
         %>"><%= NetworkHelper.escapeStringForHtml(
                  relation.rightType().getSimpleName()) %></a>
    </td>
    <td class="admconfvalue" align="right">
      <a href="<%= NetworkHelper.escapeStringForHtml(
          context.getCmdURL(
              "admin-relation-view",
              new String[] { "relation" },
              new String[] { relation.tableName() }))
         %>">View</a>
      <a href="<%= NetworkHelper.escapeStringForHtml(
          context.getCmdURL(
              "admin-relation-reset",
              new String[] { "relation" },
              new String[] { relation.tableName() })) 
        %>">Reset</a> 
    </td>
  </tr>
  <% } %>
</table>

<%= paging.render(context) %>

<%@ include file="include-custom-page-footer.jsp" %>

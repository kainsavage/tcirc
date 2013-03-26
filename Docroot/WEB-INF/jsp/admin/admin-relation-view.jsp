<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-relation-view.jsp
// View a relation
//
// ----------------------------------------------------------------------

CachedRelation<?, ?> relation = (CachedRelation<?, ?>)context.getDelivery("relation");
List<Identifiable[]> pairs = context.getDelivery("pairs");
BasicAdminPaging paging = (BasicAdminPaging)context.getDelivery("paging");
String relationType = context.getStringDelivery("relationType");
List<CachedRelationListener> relationListeners = context.getDelivery("relationListeners");
message = context.getStringDelivery("Message");

vars.title = getTitle(relation.tableName());
nav.add(new SimpleLink("Relation List", context.getCmdURL("admin-relation-list")));
nav.add(new SimpleLink(relation.tableName(), context.getCmdURL("admin-relation-view", new String[] { "relation" }, new String[] { relation.tableName() })));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2><%= NetworkHelper.escapeStringForHtml(relation.tableName()) %></h2>

<table border="0" cellpadding="0" cellspacing="0">
  <tr><td class="admconfitem">Type:<td><td class="admconfvalue"><%= NetworkHelper.escapeStringForHtml(relationType) %></td></tr>
  <tr><td class="admconfitem">Size:<td><td class="admconfvalue"><%= paging.getItemCount() %></td></tr>
  <tr><td class="admconfitem">Listeners:<td><td class="admconfvalue"><%= relationListeners.size() %></td></tr>
</table>

<% if (relationListeners.size() > 0) { %>
<ul>
  <% for (CachedRelationListener listener : relationListeners) { %>
  <li><%= NetworkHelper.escapeStringForHtml(listener.getClass().getName()) %></li>
  <% } %>
</ul>
<% } %>

<%= paging.render(context) %>

<table border="0" cellpadding="0" cellspacing="0">
  <tr class="admheader">
    <td>Left Value</td>
    <td>Right Value</td>
    <td align="right">Actions</td>
  </tr>
  <% for (Identifiable[] pair : pairs) { %>
  <tr>
    <td class="admconfitem">
      <% if(pair[0] != null) { %>
      <a href="<%= NetworkHelper.escapeStringForHtml(
          context.getCmdURL(
              "admin-object-view",
              new String[] { "cid", "id" },
              new String[] { pair[0].getClass().getName(), pair[0].getId() + "" }))
         %>"><%= NetworkHelper.escapeStringForHtml(pair[0].toString()) %></a>
      <% } else { %>NULL<% } %>
    </td>
    <td class="admconfitem">
      <% if(pair[0] != null && pair[1] != null) { %>
      <a href="<%= NetworkHelper.escapeStringForHtml(
          context.getCmdURL(
              "admin-object-view",
              new String[] { "cid", "id" },
              new String[] { pair[1].getClass().getName(), pair[1].getId() + "" }))
         %>"><%= NetworkHelper.escapeStringForHtml(pair[1].toString()) %></a>
      <% } else { %>NULL<% } %>
    </td>
    <td class="admconfvalue" align="right">
      <% if(pair[0] != null && pair[1] != null) { %>
      <a href="<%= NetworkHelper.escapeStringForHtml(
          context.getCmdURL(
              "admin-relation-remove",
              new String[] { "relation", "left", "right" },
              new String[] { relation.tableName(), pair[0].getId() + "", pair[1].getId() + "" }))
         %>">Remove</a>
      <% } else { %>NULL<% } %>
    </td>
  </tr>
  <% } %>
</table>

<%= paging.render(context) %>

<%@ include file="include-custom-page-footer.jsp" %>

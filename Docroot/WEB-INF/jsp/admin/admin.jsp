<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin.jsp
// Admin main menu
//
// ----------------------------------------------------------------------

Iterator<BasicAdminHandler.AdminCategoryMenu> menus = (Iterator<BasicAdminHandler.AdminCategoryMenu>)context.getDelivery("Menus");
int count = context.getIntDelivery("MenuCount");
int left = (count / 2) + (count % 2);
int num = 0;

message = context.getStringDelivery("Message");
vars.title = getTitle("Main Menu");

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Administration Menu</h2>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr>
<td valign="top" width="50%">

<%
while (num++ < left)
{
  BasicAdminHandler.AdminCategoryMenu menu = menus.next();
  Iterator<AdminFunction> functions = menu.getFunctions();
  AdminFunction function;
  %>
<div class="admmenusection">
  <div class="admbanner"><%= menu.getDescription() %>
    <div class="admaccent"><%= menu.getName() %></div>
  </div>
  <div class="admoptions">
    <table border="0" cellpadding="0" cellspacing="0">
      <%
      while (functions.hasNext())
      {
        function = functions.next();
        %>
      <tr>
        <td width="25%"><a href="<%= context.getCmdURL(function.getCommand()) %>"><%= function.getFunctionName() %></a></td>
        <td width="75%"><%= function.getFunctionDescription() %></td>
      </tr>
      <%
      }
      %>
    </table>
  </div>
</div>
<%
}
%>

</td>
<td>&nbsp;&nbsp;</td>
<td valign="top" width="50%">

<%
while (menus.hasNext())
{
  BasicAdminHandler.AdminCategoryMenu menu = menus.next();
  Iterator<AdminFunction> functions = menu.getFunctions();
  AdminFunction function;
  %>
<div class="admmenusection">
  <div class="admbanner"><%= menu.getDescription() %>
    <div class="admaccent"><%= menu.getName() %></div>
  </div>
  <div class="admoptions">
    <table border="0" cellpadding="0" cellspacing="0">
      <%
      while (functions.hasNext())
      {
        function = functions.next();
        %>
      <tr>
        <td width="25%"><a href="<%= context.getCmdURL(function.getCommand()) %>"><%= function.getFunctionName() %></a></td>
        <td width="75%"><%= function.getFunctionDescription() %></td>
      </tr>
      <%
      }
      %>
    </table>
  </div>
</div>
<%
}
%>

</td>
</tr>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-obj-view.jsp
// View arbitrary object
//
// ----------------------------------------------------------------------

Map fields = (Map)context.getDelivery("Fields");
List methods = (List)context.getDelivery("Methods");
Object obj = context.getDelivery("Object");
Map<String, int[]> relations = (Map<String, int[]>)context.getDelivery("Relations");
JavaScriptWriter jsW = JavaScriptWriter.standard();
Iterator iter;

vars.title = getTitle("View " + obj);

nav.add(new SimpleLink("Cache List", context.getCmdURL("admin-cache-list")));
nav.add(new SimpleLink("Object List", context.getCmdURL("admin-object-list&cid=" + obj.getClass().getName())));

%><%@ include file="include-custom-page-header.jsp" %>
<style>

table.attributes
{
  float:left;
  margin-right: 10px;
}

</style>

<%@ include file="include-message.jsp" %>

<h2>Object <%= obj %></h2>

<table class="attributes" border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
<td>Field</td><td>Value</td>
</tr>
<tbody id="fields">
</tbody>
</table>

<table class="attributes" border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
<td>Method</td><td colspan="2">Value</td>
</tr>
<tr>
<td>&nbsp;</td><td colspan="2" class="admconfvalue"><a href="javascript:callAllMethods()">Invoke all get methods</a></td>
</tr>
<tbody id="methods">
</tbody>
</table>

<table class="attributes" border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
<td rowspan="2">Relation</td><td colspan="2"># Related Values</td>
</tr>
<tr class="admheader">
<td align="right">Left</td><td align="right">Right</td>
</tr>
<% for (Map.Entry<String, int[]> entry : relations.entrySet()) { %>
<tr>
<td class="admconfitem">
  <a href="<%= NetworkHelper.escapeStringForHtml(
      context.getCmdURL(
          "admin-relation-view",
          new String[] { "relation" }, 
          new String[] { entry.getKey() })) 
     %>"><%= NetworkHelper.escapeStringForHtml(entry.getKey()) %></a>
</td>
<td class="admconfvalue" align="right"><%= entry.getValue()[0] %></td>
<td class="admconfvalue" align="right"><%= entry.getValue()[1] %></td>
</tr>
<% } %>
</table>

<div style="clear: both"></div>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

callUrl = '<%= context.getCmdURL("admin-object-call&cid=" + obj.getClass().getName() + "&id=" + context.getIntRequestValue("id")) %>';
fields = <%= jsW.write(fields) %>;
methods = <%= jsW.write(methods) %>;

content = ""
for (var key in fields)
{
  content += "<tr><td class='admconfitem'>" + key + "</td><td class='admconfvalue'>" + fields[key] + "</td></tr>";
}
$("#fields").html(content);

content = ""
for (i = 0; i < methods.length; i++)
{
  content += "<tr><td class='admconfitem'>" 
    + methods[i] 
    + "</td><td class='admconfvalue'><a href='javascript:callMethod(\""
    + methods[i]
    + "\")'>Invoke</a></td><td id='mv"
    + methods[i]
    + "' class='admconfvalue'>--</td></tr>";
}
$("#methods").html(content);

function callMethod(methodName)
{
  $.ajax({
    url : callUrl + "&m=" + methodName,
    dataType: 'json',
    success: function(data)
      {
        $("td#mv" + methodName).text(data.r);
      },
    error: function(req, status, error)
      {
        $("td#mv" + methodName).text("-- Error --");
      }
    });
}

function callAllMethods()
{
  $.ajax({
    url : callUrl + "&m=all",
    dataType: 'json',
    success: function(data)
      {
        result = data.r
        for (var key in result)
        {
          $("td#mv" + key).text(result[key]);
        }
      },
    error: function(req, status, error)
      {
      }
    });
}

</script>
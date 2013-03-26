<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-notifications.jsp
// View the historical list of Notifications (captured since application
// start-up, but limited by a configurable maximum size)
//
// ----------------------------------------------------------------------

String jsNotifications = (String)context.getDelivery("notifications");

vars.title = getTitle("Administrative Notifications");

nav.add(new SimpleLink("Notifications", context.getCmdURL("admin-notifications")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Administrative Notifications</h2>

<style>
div#listbox
{
  display: inline-block;
  max-height: 150px;
  overflow-y: scroll;
  margin: 0px 0px 12px 0px;
}
table#list
{
}
div#detailbox
{
  background-color: rgb(250,252,254);
  border: 2px solid rgb(150,152,154);
  margin: 0px 0px 10px 0px;
}
div#detailbanner
{
  padding: 1px 6px 1px 6px;
  font-weight: bold;
  border-bottom: 1px solid rgb(150,152,154);
}
tr.selected td
{
  background-color: rgb(250,240,130);
}
tr.high td
{
  color: rgb(140,0,0);
}
tr.low td
{
  color: rgb(100,100,100);
}
</style>

<div id="listbox">
  <table id="list" border="0" cellpadding="0" cellspacing="0">
  <tr class="admheader">
    <td>Time</td>
    <td>Severity</td>
    <td>Synopsis</td>
    <td>Source</td>
  </tr>
  <tbody id="not">
  <tr>
    <td class="admconfvalue" colspan="3" align="center">-- No notifications captured yet --</td>
  </tr>
  </tbody>
  </table>
</div>

<div id="detailbox">
  <div id="detailbanner">Detail</div>
  <textarea id="detail" class="largedetails" readonly="yes" enabled="no"></textarea>
</div>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">
var not = <%= jsNotifications %>;
renderNotifications(not, "#not");

function renderNotifications(not, elementID) {
  if (not.length > 0) {
    var content = "";
    for (var i in not) {
      content += "<tr id='row" + i + "' onclick='viewNotificationDetails(" + i + ");' class='" + not[i].severity.toLowerCase() + "'>";
      content += "<td class='admconfvalue'><a href='javascript:viewNotificationDetails(" + i + ");'>" + standardDateString(new Date(not[i].time)) + "</a></td>";
      content += "<td class='admconfvalue'>" + not[i].severity.toLowerCase() + "</td>";
      content += "<td class='admconfvalue'>" + abbrTruncate(not[i].synopsis, 55, 500) + "</td>";
      content += "<td class='admconfvalue'>" + abbrTruncate(not[i].source, 30) + "</td>";
      content += "</tr>";
    }
    $(elementID).html(content);
    viewNotificationDetails(0);
  }
}

function viewNotificationDetails(index) {
  $("#detail").val(not[index].details);
  $("#not").find("tr").removeClass("selected");
  $("#row" + index).addClass("selected");
}
</script>
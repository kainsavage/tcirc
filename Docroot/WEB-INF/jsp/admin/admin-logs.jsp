<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-logs.jsp
// List and control threshold levels of Log Listeners
//
// ----------------------------------------------------------------------

Iterator<LogListener> iter = context.getDelivery("LogListeners");

vars.title = getTitle("Log Thresholds");

nav.add(new SimpleLink("Thresholds", context.getCmdURL("admin-logs")));
nav.add(new SimpleLink("Monitors", context.getCmdURL("admin-log-monitor")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Log Thresholds</h2>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td>Log</td>
  <td colspan="2">Threshold</td>
</tr>
<%
LogListener listener;
FormSelect menu;
int ix = 0;
while (iter.hasNext())
{
  listener = iter.next();
  ix++;
  menu = new FormSelect("ix" + ix);
  menu.addOptionsFromArray(LogLevel.DENSE_LEVEL_VALUES, LogLevel.DENSE_LEVEL_NAMES)
      .setValue(listener.getDebugThreshold());
  %><tr>
  <td class="admconfitem" style="vertical-align: middle"><%= listener.getName() %></td>
  <td class="admconfvalue"><%= menu %></td>
  <td class="admconfvalue" style="vertical-align: middle">(Include messages at this level and above)</td>
  </tr><%
}
%>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

var svUrl = '<%= context.getURL() %>';
var ix = <%= ix %>;
for (i = 1; i <= ix; i++)
{
  $("#ix" + i).change(function()
  {
    // Update the threshold.
    $.ajax({
      url: svUrl + "?cmd=admin-logs",
      dataType: 'json',
      type: 'post',
      data: { "ix": this.name.substring(2), "level": this.value },
      success: function(data)
      {
      },
      failure: function()
      {
      }
    });
  });
}

</script>

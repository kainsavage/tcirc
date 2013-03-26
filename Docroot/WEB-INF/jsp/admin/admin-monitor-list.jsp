<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-monitor-list.jsp
// List Monitored Dispatcher Commands / Performance Monitoring
//
// ----------------------------------------------------------------------

String commands = context.getStringDelivery("Commands");
boolean includeSpecialTime = true;  // Set to false to hide the Special Time columns.
vars.title = getTitle("Performance Monitoring");

nav.add(new SimpleLink("Performance", context.getCmdURL("admin-monitor-list")));
nav.add(new SimpleLink("CPU Usage", context.getCmdURL("admin-monitor-cpu")));
nav.add(new SimpleLink("Current Requests", context.getCmdURL("admin-monitor-current")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Performance Monitoring</h2>
<div style="float: right"><a href="javascript:openWatch()">Open Watch</a> | <input type="checkbox" id="refr" name="refr" value="1" /><label for="refr">&nbsp;Automatically refresh</label></div>
<p>The following commands have been observed in the application's <%= context.getStringDelivery("Uptime") %>.</p>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td rowspan="2" valign="bottom">Command</td>
  <td rowspan="2" valign="bottom"><abbr title="Current load">CL</abbr></td>
  <td rowspan="2" valign="bottom"><abbr title="Count since application start">Count</abbr></td>
  <td rowspan="2" valign="bottom"><abbr title="Count in last hour">LH</abbr></td>
  <td class="separator">&nbsp;</td>
  <td colspan="<%= (includeSpecialTime ? 9 : 8) %>" align="center">Average in last hour</td>
  <td class="separator">&nbsp;</td>
  <td colspan="<%= (includeSpecialTime ? 7 : 5) %>" align="center">Worst in last hour</td>
  <td class="separator">&nbsp;</td>
  <td colspan="<%= (includeSpecialTime ? 10 : 9) %>" align="center">Most recent request</td>
</tr>
<tr class="admheader">
  <td class="separator">&nbsp;</td>
  <td align="right"><abbr title="Dispatches">Ds</abbr></td>
  <td align="right"><abbr title="Queries">Qs</abbr></td>
  <td align="right"><abbr title="Query Exceptions">QEs</abbr></td>
  <td align="right"><abbr title="Query Time">QT</abbr></td>
  <% if (includeSpecialTime) { %><td align="right"><abbr title="Special Time">ST</abbr></td><% } %>
  <td align="right"><abbr title="Logic Time">LT</abbr></td>
  <td align="right"><abbr title="Render Time">RT</abbr></td>
  <td align="right"><abbr title="CPU Time">CT</abbr></td>
  <td align="right">Total</td>
  <td class="separator">&nbsp;</td>
  <td align="right"><abbr title="Queries">Qs</abbr></td>
  <td align="right"><abbr title="Query Exceptions">QEs</abbr></td>
  <td align="right"><abbr title="Query Time">QT</abbr></td>
  <% if (includeSpecialTime) { %><td align="right"><abbr title="Special Time">ST</abbr></td><% } %>
  <td align="right"><abbr title="Logic Time">LT</abbr></td>
  <td align="right"><abbr title="Render Time">RT</abbr></td>
  <td align="right"><abbr title="CPU Time">CT</abbr></td>
  <td class="separator">&nbsp;</td>
  <td>Time</td>
  <td align="right"><abbr title="Dispatches">Ds</abbr></td>
  <td align="right"><abbr title="Queries">Qs</abbr></td>
  <td align="right"><abbr title="Query Exceptions">QEs</abbr></td>
  <td align="right"><abbr title="Query Time">QT</abbr></td>
  <% if (includeSpecialTime) { %><td align="right"><abbr title="Special Time">ST</abbr></td><% } %>
  <td align="right"><abbr title="Logic Time">LT</abbr></td>
  <td align="right"><abbr title="Render Time">RT</abbr></td>
  <td align="right"><abbr title="CPU Time">CT</abbr></td>
  <td>Total</td>
</tr>
<tbody id='cmds'>
</tbody>
</table>

<p>Ds: Dispatches; Qs: Queries; QEs: Query errors; QT: Query Time; <% if (includeSpecialTime) { %>ST: Special Time; <% } %>LT: Logic Time; RT: Render Time</p>

<%@ include file="include-custom-page-footer.jsp" %>


<script type="text/javascript">

var svUrl = '<%= context.getURL() %>';
var detail = '<%= context.getCmdURL("admin-monitor-detail&command=") %>';
var exc = 5;
var commands = <%= commands %>;
var content = "";
var concurrencyHighlight = 10;

function openWatch()
{
  window.open("<%= inf.getHtmlDirectory() %>admin-compact-performance-monitor.html", "PerformanceMonitor", "resizeable=yes,scrollbars=yes,status=no,menubar=no,toolbar=no,width=500,height=680");
}

function render(commands)
{
  $("tbody#cmds").html(renderPerformanceMonitorList(commands, detail, exc, <%= (includeSpecialTime ? 1 : 0) %>, concurrencyHighlight));
};

function refresh()
{
  var checked = $("input#refr:checked").length;

  if (checked == 1)
  {
    $.ajax({
      url: svUrl + "?cmd=admin-monitor-list&mode=1",
      dataType: 'json',
      type: 'get',
      data: {},
      success: function(data)
        {
          render(data.commands);
        }
      });
  }
}

render(commands);
window.setInterval(refresh, 5000);

</script>
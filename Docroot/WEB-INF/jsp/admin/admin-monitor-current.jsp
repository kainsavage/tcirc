<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-monitor-list.jsp
// List Current Requests / Performance Monitoring
//
// ----------------------------------------------------------------------

String requests = context.getStringDelivery("Requests");
boolean includeSpecialTime = true;  // Set to false to hide the Special Time columns.
vars.title = getTitle("Current Requests - Performance Monitoring");

nav.add(new SimpleLink("Performance", context.getCmdURL("admin-monitor-list")));
nav.add(new SimpleLink("CPU Usage", context.getCmdURL("admin-monitor-cpu")));
nav.add(new SimpleLink("Current Requests", context.getCmdURL("admin-monitor-current")));

%><%@ include file="include-custom-page-header.jsp" %>
<%@ include file="include-message.jsp" %>

<h2>Current Requests</h2>
<div style="float: right"><a href="javascript:openWatch()">Open Watch</a> |<input type="checkbox" id="refr" name="refr" value="1" /><label for="refr">&nbsp;Automatically refresh</label></div>
<p>The following commands are being processed right now.</p>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td>Command</td>
  <td><abbr title="Request Number">Req</abbr></td>
  <td><abbr title="Thread ID">TID</abbr></td>
  <td><abbr title="Request start time">Time</abbr></td>
  <td class="separator">&nbsp;</td>
  <td align="right"><abbr title="Dispatches">Ds</abbr></td>
  <td align="right"><abbr title="Queries">Qs</abbr></td>
  <td align="right"><abbr title="Query Exceptions">QEs</abbr></td>
  <td align="right"><abbr title="Query Time">QT</abbr></td>
  <% if (includeSpecialTime) { %><td align="right"><abbr title="Special Time">ST</abbr></td><% } %>
  <td align="right"><abbr title="Logic Time">LT</abbr></td>
  <td align="right"><abbr title="Render Time">RT</abbr></td>
  <td align="right"><abbr title="CPU Time">CT</abbr></td>
  <td align="right"><abbr title="Total time">Total</abbr></td>
</tr>
<tbody id='reqs'>
</tbody>
</table>

<p>Ds: Dispatches; Qs: Queries; QEs: Query errors; QT: Query Time; <% if (includeSpecialTime) { %>ST: Special Time; <% } %>LT: Logic Time; RT: Render Time</p>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

var svUrl = '<%= context.getURL() %>';
var detail = '<%= context.getCmdURL("admin-thread-view&id=") %>';
var requests = <%= requests %>;
var content = "";

function openWatch()
{
  window.open("<%= inf.getHtmlDirectory() %>admin-compact-performance-monitor.html", "PerformanceMonitor", "resizeable=yes,scrollbars=yes,status=no,menubar=no,toolbar=no,width=500,height=680");
}

function render(requests)
{
  $("tbody#reqs").html(renderCurrentRequestList(requests, detail, <%= (includeSpecialTime ? 1 : 0) %>));
};

function refresh()
{
  var checked = $("input#refr:checked").length;

  if (checked == 1)
  {
    $.ajax({
      url: svUrl + "?cmd=admin-monitor-current&mode=1",
      dataType: 'json',
      type: 'get',
      data: {},
      success: function(data)
        {
          render(data.requests);
        }
      });
  }
}

render(requests);
window.setInterval(refresh, 5000);

</script>


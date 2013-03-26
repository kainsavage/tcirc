<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-monitor-cpu.jsp
// Displays CPU utilization by thread.
//
// ----------------------------------------------------------------------

String samples = (String)context.getDelivery("Samples");

vars.title = getTitle("CPU Usage Monitoring");

nav.add(new SimpleLink("Performance", context.getCmdURL("admin-monitor-list")));
nav.add(new SimpleLink("CPU Usage", context.getCmdURL("admin-monitor-cpu")));
nav.add(new SimpleLink("Current Requests", context.getCmdURL("admin-monitor-current")));

%><%@ include file="include-custom-page-header.jsp" %>

<div style="float: right"><input type="checkbox" id="refr" name="refr" value="1" onclick="refresh()" /><label for="refr">&nbsp;Automatically refresh</label></div>
<h2>CPU Usage Monitoring</h2>

<table border="0" cellpadding="0" cellspacing="0" class="threadlist">
<tr class="admheader">
  <td>Name</td>
  <td align="right">ID</td>
  <td align="right">CPU ms</td>
  <td align="right">CPU %</td>
  <td>Actions</td>
</tr>
<tbody id="data"></tbody>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

var svUrl = '<%= context.getURL() %>';
var samples = <%= samples %>;

function render(samples) {
  var content = "";
  for (var i in samples) {
    content += "<tr><td class='admconfitem'>" + samples[i].name + "</td>";
    content += "<td align='right' class='admconfvalue'>" + samples[i].id + "</td>";
    content += "<td align='right' class='admconfvalue'>" + samples[i].ms + " ms</td>";
    content += "<td align='right' class='admconfvalue'>" + samples[i].usage + " %</td>";
    content += "<td class='admconfvalue'><a href='" + svUrl + "?cmd=admin-thread-view&id=" + samples[i].id + "'>View</a></td></tr>";
  }

  $("tbody#data").html(content);
}

function refresh() {
  var checked = $("input#refr:checked").length;
  if (checked == 1) {
    $.ajax({
      url: svUrl + "?cmd=admin-monitor-cpu&mode=1",
      dataType: 'json',
      type: 'get',
      data: {},
      success: function(data) {
        render(data.samples);
      }
    });
    setTimeout(refresh, 1000);
  }
}

render(samples);
refresh();
</script>

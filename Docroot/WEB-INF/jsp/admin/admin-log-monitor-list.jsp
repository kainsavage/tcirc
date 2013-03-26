<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-log-monitor-list.jsp
// List Log Monitor channels
//
// ----------------------------------------------------------------------

String channels = context.getStringDelivery("Channels");

vars.title = getTitle("Log Monitor Channels");

nav.add(new SimpleLink("Thresholds", context.getCmdURL("admin-logs")));
nav.add(new SimpleLink("Monitors", context.getCmdURL("admin-log-monitor")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Log Monitor Channels</h2>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td>Name</td>
  <td>Min</td>
  <td>Max</td>
  <td>Contains</td>
  <td>Regular Expression</td>
  <td>Count</td>
  <td>Last Capture</td>
</tr>
<tbody id="channels">
</tbody>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

var svUrl = '<%= context.getURL() %>';
var channels = <%= channels %>;

renderChannels();

function renderChannels()
{
  var toAdd = "";
  for (i = 0; i < channels.length; i++)
  {
    toAdd += "<tr>"
      + "<td class='admconfitem'><a href='" + svUrl + "?cmd=admin-log-monitor&act=view&ch=" + i + "'>" + channels[i].name + "</a></td>"
      + "<td class='admconfvalue' align='right'>" + channels[i].min + "</td>"
      + "<td class='admconfvalue' align='right'>" + channels[i].max + "</td>"
      + "<td class='admconfvalue'>" + (channels[i].contains ? channels[i].contains : "--") + "</td>"
      + "<td class='admconfvalue'>" + (channels[i].regex ? channels[i].regex : "--") + "</td>"
      + "<td class='admconfvalue' align='right'>" + channels[i].count + "</td>"
      + "<td class='admconfvalue'>" + (channels[i].last > 0 ? standardDateString(new Date(channels[i].last)) : "--") + "</td>";
  }

  $("tbody#channels").html(toAdd);
}

</script>
<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-log-monitor.jsp
// Real-time monitoring of logs
//
// ----------------------------------------------------------------------

String date = DateHelper.STANDARD_TECH_FORMAT.format(new Date());
int channelID = context.getIntDelivery("ChannelID");
String channels = context.getStringDelivery("Channels");

%><%!

protected void initSas()
{
  getSas().addSheet("basicadmin-logmonitor.css");
  getSas().addScript("basicadmin.js");
  getSas().addScript("basicadmin-logmonitor.js");
}

%><html><head>
<title><%= app.getVersion().getProductName() %> Log [<%= app.getVersion().getDeploymentDescription() %>]</title>
<%= renderSheets(context, vars.sas) %>
</head>

<body onload="startLogMonitor();">
<div id='banner'>
  <%= app.getVersion().getProductName() %> [<%= app.getVersion().getDeploymentDescription() %>]<br/>
  <span id='channel'>
  </span><br/>
  <span id='stats'>
    <span id='displayed'>0</span> displayed; <span id='captured'>0</span> captured
  </span><br/>
  <span id='levels'>
    <a href="javascript:setThreshold(0)" id='t0'>0</a>
    <a href="javascript:setThreshold(10)" id='t10'>10</a>
    <a href="javascript:setThreshold(30)" class='selected' id='t30'>30</a>
    <a href="javascript:setThreshold(50)" id='t50'>50</a>
    <a href="javascript:setThreshold(70)" id='t70'>70</a>
    <a href="javascript:setThreshold(90)" id='t90'>90</a>
    <a href="javascript:setThreshold(100)" id='t100'>100</a>
  </span>
  <span id='controls'>
    <input name='filter' id='filter' value='' />
    <a href="javascript:toggleCapture()" id='togglecapture'>Pause</a>
    <a href="javascript:toggleTrack()" id='toggletrack' class='selected'>Follow</a>
  </span>
</div>
<div id='log'><table cellpadding='0' cellspacing='0'><tbody id='logdata'></tbody></table></div>
</body>

<script type="text/javascript">
var svUrl = '<%= context.getURL() %>';
var channelID = <%= channelID %>;
var channels = <%= channels %>;
var channel = channels[channelID];
var maxLines = channel.size;
</script>
<%= renderScripts(context, vars.sas) %>
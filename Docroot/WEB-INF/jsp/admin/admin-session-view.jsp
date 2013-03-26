<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-session-view.jsp
// View session trend
//
// ----------------------------------------------------------------------

SessionSnapshot[] snapshots = (SessionSnapshot[])context.getDelivery("SessionSnapshots");
SessionManager manager = (SessionManager)context.getDelivery("SessionManager");

int timeoutSeconds = manager.getTimeoutSeconds();
int timeoutMinutes = timeoutSeconds / 60;

int sampleCount = 0;
int samplesToShow = 25;

message = context.getStringDelivery("Message");

vars.title = getTitle("Session Trend");
onload = "";

nav.add(new SimpleLink("Session Trend", context.getCmdURL("admin-session-view")));
nav.add(new SimpleLink("Session List", context.getCmdURL("admin-session-list")));

%><%!
protected void initSas()
{
  // Add Flot.
  super.initSas();
  getSas().addScript("jquery.flot.js", "jquery.flot.min.js");
  getSas().addScript("jquery.flot.selection.js", "jquery.flot.selection.min.js");
  getSas().addScript("jquery.flot.crosshair.js", "jquery.flot.crosshair.min.js");
  getSas().addScript("jquery.flot.stack.js", "jquery.flot.stack.min.js");
}
%><%@ include file="include-custom-page-header.jsp" %>
<%@ include file="include-message.jsp" %>
<style>
tr.hidden
{
  display: none;
}
</style>

<h2>Session Trend</h2>

<div style="float: left; margin-right: 20px;">
  <div id="placeholder" style="width:550px;height:300px;"></div>
  <p>Click and drag to select a region in the overview below:</p>
  <div id="overview" style="margin-top:20px;width:550px;height:50px"></div>
  <p>Session timeout: <%= timeoutSeconds %> second<%= StringHelper.pluralize(timeoutSeconds) %> (<%= timeoutMinutes %> minutes<%= StringHelper.pluralize(timeoutMinutes) %>)</p>
</div>

<p id="hideshowsamples">
  Most recent <%= samplesToShow %> samples shown.  <a href="javascript:showSamples()">Show all</a> samples.
</p>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td>Sample Time</td>
  <td>Count</td>
</tr>

<%
for (int i = 0; i < snapshots.length; i++)
{
  SessionSnapshot snapshot = snapshots[i];
  if (snapshot != null)
  {
    String rowClass;
    if (i + samplesToShow > sampleCount)
    {
      rowClass = "";
    }
    else
    {
      rowClass = "extras hidden";
    }
    %><tr class="<%= rowClass %>">
    <td class="admconfitem"><%= DateHelper.STANDARD_TECH_FORMAT.format(new Date(snapshot.getSampleTime())) %></td>
    <td class="admconfvalue" align="right"><%= snapshot.getSessionCount() %></td>
    </tr><%
  }
}
%>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

function showSamples()
{
  $("tr.extras").toggleClass("hidden");
  if ($("tr.extras").hasClass("hidden"))
  {
    $("p#hideshowsamples").html("Most recent <%= samplesToShow %> samples shown.  <a href='javascript:showSamples()'>Show all</a> samples.");
  }
  else
  {
    $("p#hideshowsamples").html("All samples shown.  <a href='javascript:showSamples()'>Show only most recent <%= samplesToShow %></a> samples.");
  }
}

$(function () {

var d = [<%
for (int i = 0; i < snapshots.length; i++)
{
  SessionSnapshot snapshot = snapshots[i];
  if (snapshot != null)
  {
    %>[<%= snapshot.getSampleTime() %>, <%= snapshot.getSessionCount() %>]<%
    if (i < snapshots.length - 1)
    {
      %>,<%
    }
  }
}

    %>];

// This is borrowed fairly directly from the Flot examples.  Will want
// to clean it up eventually.

    // first correct the timestamps - they are recorded as the daily
    // midnights in UTC-0800, but Flot always displays dates in UTC
    // so we have to add one hour to hit the midnights in the plot
    for (var i = 0; i < d.length; ++i)
      d[i][0] -= 7 * 60 * 60 * 1000;

    // helper for returning the weekends in a period
    function weekendAreas(axes) {
        var markings = [];
        var d = new Date(axes.xaxis.min);
        // go to the first Saturday
        d.setUTCDate(d.getUTCDate() - ((d.getUTCDay() + 1) % 7))
        d.setUTCSeconds(0);
        d.setUTCMinutes(0);
        d.setUTCHours(0);
        var i = d.getTime();
        do {
            // when we don't set yaxis the rectangle automatically
            // extends to infinity upwards and downwards
            markings.push({ xaxis: { from: i, to: i + 2 * 24 * 60 * 60 * 1000 } });
            i += 7 * 24 * 60 * 60 * 1000;
        } while (i < axes.xaxis.max);

        return markings;
    }

    var options = {
        xaxis: { mode: "time", timeformat: "%m-%d %h:%M"},
        yaxis: { min: 0, minTickSize: 1, tickDecimals: 0 },
        selection: { mode: "x" },
        colors: [ "#5060F0" ],
        grid: { markings: weekendAreas, backgroundColor: { colors: ["#FFF", "#FFF", "#FFF", "#F0F4F8"] } }
    };

    var plot = $.plot($("#placeholder"), [d], options);

    var overview = $.plot($("#overview"), [d], {
        lines: { show: true, lineWidth: 1 },
        shadowSize: 0,
        xaxis: { ticks: [], mode: "time" },
        yaxis: { min: 0, minTickSize: 1, tickDecimals: 0 },
        selection: { mode: "x" },
        colors: [ "#5060F0" ],
        grid: { backgroundColor: { colors: ["#FFF", "#FFF", "#FFF", "#F0F4F8"] } }
    });

    // now connect the two
    
    $("#placeholder").bind("plotselected", function (event, ranges) {
        // do the zooming
        plot = $.plot($("#placeholder"), [d],
                      $.extend(true, {}, options, {
                          xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }
                      }));

        // don't fire event on the overview to prevent eternal loop
        overview.setSelection(ranges, true);
    });
    
    $("#overview").bind("plotselected", function (event, ranges) {
        plot.setSelection(ranges);
    });
});
</script>

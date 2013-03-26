<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-monitor-detail.jsp
// Detailed view of Monitored Dispatcher Commands / Performance Monitoring
//
// ----------------------------------------------------------------------

String command = context.getStringDelivery("Command");
String mc = context.getStringDelivery("MC");
String history = context.getStringDelivery("History");
long intervalLength = ((Long)context.getDelivery("IntervalLength")).longValue();
int timezoneOffset = context.getIntDelivery("TimezoneShift");

vars.title = getTitle("Performance Monitoring for " + command);

nav.add(new SimpleLink("Performance", context.getCmdURL("admin-monitor-list")));
nav.add(new SimpleLink("CPU Usage", context.getCmdURL("admin-monitor-cpu")));
nav.add(new SimpleLink("Current Requests", context.getCmdURL("admin-monitor-current")));

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

<h2>Performance Monitoring for <%= command %></h2>

<table border="0" cellpadding="0" cellspacing="0">
<tr><td style="padding-right: 20px;" rowspan="2">
<div id="hits" style="width:490px;height:100px;"></div>
<h3>Averages</h3>
<div id="averages" style="width:490px;height:200px;"></div>
<h3>Exceptional Cases</h3>
<div id="worst" style="width:490px;height:200px;"></div>
</td><td style="border-left: 1px solid #C0C0D0; padding-left: 20px; vertical-align: top">
<div id="hover" style="width: 200px;">-- No selection --</div>
<p style="color: #909090">Note that logic time above includes query time.</p>
</td></tr><tr><td style="border-left: 1px solid #C0C0D0; padding-left: 20px; vertical-align: bottom">
<div id="legend"></div>
</td>
</tr></table>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

var svUrl = '<%= context.getURL() %>';
var mc = <%= mc %>;
var h = <%= history %>;
var interval = <%= intervalLength %>;
var timezoneShift = <%= timezoneOffset %>;

var count = new Array();
var avglg = new Array();
var avgqr = new Array();
var avgqe = new Array();
var avgqt = new Array();
var avgrn = new Array();
var avgsp = new Array();
var worlg = new Array();
var worqr = new Array();
var worqe = new Array();
var worqt = new Array();
var worrn = new Array();
var worsp = new Array();

var lastTime;

for (var i = 0; i < h.length; i++)
{
  if (h[i] != null)
  {
    lastTime = h[i].time + timezoneShift;
    count[i] = [lastTime, h[i].count];
    avglg[i] = [lastTime, h[i].avglg - (h[i].avgqt + h[i].avgsp)];
    avgqr[i] = [lastTime, h[i].avgqr];
    avgqt[i] = [lastTime, h[i].avgqt];
    avgrn[i] = [lastTime, h[i].avgrn];
    avgsp[i] = [lastTime, h[i].avgsp];
    worlg[i] = [lastTime, h[i].worlg - (h[i].worqt + h[i].worsp)];
    worqr[i] = [lastTime, h[i].worqr];
    worqt[i] = [lastTime, h[i].worqt];
    worrn[i] = [lastTime, h[i].worrn];
    worsp[i] = [lastTime, h[i].worsp];
  }
}

function insertZeroData(start, end, iteration, timeAdjust)
{
  var lastTime = 0;

  for (var i = start; i != end; i += iteration)
  {
    if (h[i] != null)
    {
      lastTime = h[i].time + timezoneShift;
    }
    else if (lastTime > 0)
    {
      lastTime += timeAdjust;
      count[i] = [lastTime, 0];
      avglg[i] = [lastTime, 0];
      avgqr[i] = [lastTime, 0];
      avgqt[i] = [lastTime, 0];
      avgrn[i] = [lastTime, 0];
      avgsp[i] = [lastTime, 0];
      worlg[i] = [lastTime, 0];
      worqr[i] = [lastTime, 0];
      worqt[i] = [lastTime, 0];
      worrn[i] = [lastTime, 0];
      worsp[i] = [lastTime, 0];
    }
  }
}

insertZeroData(0, h.length, 1, -interval);
insertZeroData(h.length - 1, -1, -1, interval);

var reqOptions = {
  xaxis: { mode: "time", timeformat: "%m-%d %h:%M"},
  legend: { position: "nw" },
  yaxis: { labelWidth: 40, min: 0, minTickSize: 1, tickDecimals: 0 },
  y2axis: { labelWidth: 25, min: 0, minTickSize: 1, tickDecimals: 0 },
  selection: { mode: "x" },
  colors: [ "#5060F0" ],
  grid: { hoverable: true, backgroundColor: { colors: ["#FFF", "#FFF", "#FFF", "#F0F4F8"] },
  series: { stack: false } }
};

var mainOptions = {
  series: {
    bars: { show: true, barWidth: 60 * 60 * 1000, align: "center" }
    },
  xaxis: { mode: "time", timeformat: "%m-%d %h:%M" },
  legend: {
    position: "nw", noColumns: 2, container: "#legend",
    labelFormatter: function(label, series) {
        var index = 0; switch (series.data) { case (worqt): index = 0; break; case (worlg): index = 1; break; case (worrn): index = 2; break; case (worqr): index = 4; break; case (worsp): index = 3; break; }
        return '<a href="javascript:toggleSeries(' + index + ')">' + label + '</a>';
      }
    },
  yaxis: { labelWidth: 40, min: 0, minTickSize: 1, tickFormatter: function (v, axis) { return v + " ms"; } },
  y2axis: { labelWidth: 25, min: 0, minTickSize: 1, tickFormatter: function (v, axis) { return v + "q"; } },
  selection: { mode: "x" },
  colors: [ "#5060F0" ],
  grid: { hoverable: true, backgroundColor: { colors: ["#FFF", "#FFF", "#FFF", "#F0F4F8"] } }
};

var hits =
  [{ label: 'Requests', data: count, stack: false }];

var averages =
  [{ label: 'Query time (ms)', data: avgqt, stack: true },
   { label: 'Logic time (ms)', data: avglg, stack: true },
   { label: 'Render time (ms)', data: avgrn, stack: true },
   { label: 'Special time (ms)', data: avgsp, stack: true },
   { label: 'Queries', data: avgqr, yaxis: 2, lines: { show: true }, bars: { show: false }, stack: false }
  ];

var worst =
  [{ label: 'Query time (ms)', data: worqt, stack: true },
   { label: 'Logic time (ms)', data: worlg, stack: true },
   { label: 'Render time (ms)', data: worrn, stack: true },
   { label: 'Special time (ms)', data: worsp, stack: true },
   { label: 'Queries', data: worqr, yaxis: 2, lines: { show: true }, bars: { show: false }, stack: false }
  ];

var hitsPlot = $.plot($("#hits"), hits, reqOptions);
var avgPlot = $.plot($("#averages"), averages, mainOptions);
var worstPlot = $.plot($("#worst"), worst, mainOptions);

$("#hits").bind("plotselected", function (event, ranges) {
  avgPlot.setSelection(ranges);
  worstPlot.setSelection(ranges);
});

$("#averages").bind("plotselected", function (event, ranges) {
  // do the zooming
  avgPlot = $.plot($("#averages"), averages,
    $.extend(true, {}, mainOptions, {
      xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }
    }));
});

$("#worst").bind("plotselected", function (event, ranges) {
  // do the zooming
  worstPlot = $.plot($("#worst"), worst,
    $.extend(true, {}, mainOptions, {
      xaxis: { min: ranges.xaxis.from, max: ranges.xaxis.to }
    }));
});

function toggleSeries(index)
{
  togglePlotSeries(avgPlot, index);
  togglePlotSeries(worstPlot, index);
}

function togglePlotSeries(plotRef, seriesNumber)
{
  var series = plotRef.getData();
  var plotType = series[seriesNumber].plotType;
  if (plotType == null)
  {
    if (series[seriesNumber].lines.show)
    {
      plotType = 0;
    }
    else if (series[seriesNumber].bars.show)
    {
      plotType = 1;
    }
    series[seriesNumber].plotType = plotType;
  }

  if (plotType == 0)
  {
    var show = series[seriesNumber].lines.show;
    series[seriesNumber].lines.show = !show;
  }
  else if (plotType == 1)
  {
    var show = series[seriesNumber].bars.show;
    series[seriesNumber].bars.show = !show;
  }
  plotRef.draw();
}

var latestHover = null;
var updateHoverTimeout = null;
var latestHoverHistory = null;

function updateHover() {
  updateHoverTimeout = null;

  var hover = latestHover;
  if (hover != null)
  {
    var content = "";
    var hist = h[hover.dataIndex];

    if ((hist != latestHoverHistory) && (hist != null))
    {
      latestHoverHistory = hist;
      content += "<table cellpadding='0' cellspacing='0' border='0' width='100%'><tr class='admheader'><td colspan='2'>" + standardDateString(new Date(hist.time)) + "</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.count + "</td><td class='admconfvalue'>Requests</td></tr>"
        + "<tr class='admsubheader'><td colspan='2'>Averages</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.avgdisp + "</td><td class='admconfvalue'>Dispatches</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.avgqr + "</td><td class='admconfvalue'>Queries</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.avgqe + "</td><td class='admconfvalue'>Query&nbsp;exceptions</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.avgqt + " ms</td><td class='admconfvalue'>Query time</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.avgsp + " ms</td><td class='admconfvalue'>Special time</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.avglg + " ms</td><td class='admconfvalue'>Logic time</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.avgrn + " ms</td><td class='admconfvalue'>Render time</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.avgto + " ms</td><td class='admconfvalue'>Total time</td></tr>"
        + "<tr class='admsubheader'><td colspan='2'>Worst</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.worqr + "</td><td class='admconfvalue' id='qc'>Queries</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.worqe + "</td><td class='admconfvalue' id='qe' width='50%'>Query&nbsp;exceptions</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.worqt + " ms</td><td class='admconfvalue' id='qt'>Query time</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.worsp + " ms</td><td class='admconfvalue' id='st'>Special time</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.worlg + " ms</td><td class='admconfvalue' id='lt'>Logic time</td></tr>"
        + "<tr><td class='admconfintvalue'>" + hist.worrn + " ms</td><td class='admconfvalue' id='rt'>Render time</td></tr>"
        + "</table>";
      $("#hover").html(content);

      $.ajax({
        url: svUrl + "?cmd=admin-monitor-sigs&command=<%= command %>&interval=" + hover.dataIndex,
        dataType: 'json',
        type: 'get',
        data: {},
        success: function(data)
          {
            if (data.sigs)
            {
              if (data.sigs.qc)
                $("#hover #qc").html("<a href='" + data.sigs.qc + "'>Queries</a>");
              if (data.sigs.qe)
                $("#hover #qe").html("<a href='" + data.sigs.qe + "'>Query exceptions</a>");
              if (data.sigs.qt)
                $("#hover #qt").html("<a href='" + data.sigs.qt + "'>Query time</a>");
              if (data.sigs.st)
                $("#hover #st").html("<a href='" + data.sigs.st + "'>Special time</a>");
              if (data.sigs.lt)
                $("#hover #lt").html("<a href='" + data.sigs.lt + "'>Logic time</a>");
              if (data.sigs.rt)
                $("#hover #rt").html("<a href='" + data.sigs.rt + "'>Render time</a>");
            }
          }
        });
    }
  }
}

function hover(event, pos, item) {
  latestHover = item;
  if (!updateHoverTimeout)
    updateHoverTimeout = setTimeout(updateHover, 250);
}

$("#hits").bind("plothover", hover);
$("#averages").bind("plothover", hover);
$("#worst").bind("plothover", hover);

</script>

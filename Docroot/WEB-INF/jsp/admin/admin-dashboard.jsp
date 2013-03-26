<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-dashboard.jsp
// Dashboard view of application vital statistics.
//
// ----------------------------------------------------------------------

String attributes = context.getStringDelivery("attributes");

vars.title = getTitle("Dashboard");

%><%@ include file="include-custom-page-header.jsp" %>
<style>

div.sec
{
  vertical-align: top;
  display: inline-block;
  width: 450px;
  background-color: rgb(250,250,254);
  padding: 0px 0px 6px 0px;
  border: 1px solid rgb(200,200,204);
  margin: 0px 8px 8px 0px;
}

div.sec div.title
{
  background-color: rgb(100,100,104);
  color: white;
  font-weight: bold;
  padding: 6px 6px 6px 6px;
}

div.sec div.title div.ref
{
  float: right;
}

div.sec div.title div.ref a
{
  color: rgb(230,230,255);
}

div.sec div.title div.ref a:visited
{
  color: rgb(230,230,255);
}

div.sec div.row
{
  padding: 6px 6px 0px 6px;
  white-space: nowrap;
  overflow-x: hidden;
}

div.sec div.row div.label
{
  display: inline-block;
  width: 70px;
  color: rgb(60,60,64);
}

div.sec div.row div.val
{
  display: inline-block;
  color: black;
}

div.sec div.row
{
  clear: both;
}

</style>

<div style="float: right"><input type="checkbox" id="refr" name="refr" value="1" onclick="refresh()" /><label for="refr">&nbsp;Automatically refresh</label></div>
<h2>Application Dashboard</h2>

<div class="sec">
  <div class="title">Application</div>
  <div class="row">
    <div class="label">Name</div>
    <div class="val" id="appname"></div>
  </div>
  <div class="row">
    <div class="label">Deployment</div>
    <div class="val" id="deployment"></div>
  </div>
  <div class="row">
    <div class="label">Uptime</div>
    <div class="val"><span id="uptime"></span> (<span id="uptimems"></span> ms)</div>
  </div>
  <div class="row">
    <div class="label">Requests</div>
    <div class="val"><span id="reqnum"></span> requests processed</div>
  </div>
</div>

<div class="sec">
  <div class="title"><div class="ref"><a title="Current Requests" href="<%= context.getCmdURL("admin-monitor-current") %>">Requests</a> <a title="Performance Monitoring" href="<%= context.getCmdURL("admin-monitor-list") %>">More</a></div>Performance</div>
  <div class="row">
    <div class="label">Requests</div>
    <div class="val"><span id="reqs"></span> current request<span id="reqsplr">s<span> processing</div>
  </div>
  <div class="row">
    <div class="label">Dispatches</div>
    <div class="val"><span id="disps"></span> dispatch<span id="dispsplr">es</span> processing</div>
  </div>
  <div class="row">
    <div class="label">Pages</div>
    <div class="val"><span id="pages"></span> page<span id="pagesplr">s</span> rendering</div>
  </div>
  <div class="row">
    <div class="label">Queries</div>
    <div class="val"><span id="queries"></span> quer<span id="queriesplr">ies</span><span id="queriessng">y</span> executing</div>
  </div>
</div>

<div class="sec">
  <div class="title">Virtual Machine / Server</div>
  <div class="row">
    <div class="label">Memory</div>
    <div class="val"><span id="freememmb"></span> MiB free, <span id="totalmemmb"></span> MiB total VM memory</div>
  </div>
  <div class="row">
    <div class="label">VM</div>
    <div class="val"><span id="vm"></span> (v<span id="vmvers"></span>)</div>
  </div>
  <div class="row">
    <div class="label">Server</div>
    <div class="val" id="sc"></div>
  </div>
</div>

<div class="sec">
  <div class="title"><div class="ref"><a title="View Thread List" href="<%= context.getCmdURL("admin-thread-list") %>">More</a></div>Threads</div>
  <div class="row">
    <div class="label">Threads</div>
    <div class="val"><span id="threads"></span> VM threads</div>
  </div>
  <div class="row">
    <div class="label">Active</div>
    <div class="val"><span id="t10s"></span> thread<span id="t10splr">s</span> with greater than 10sec CPU time</div>
  </div>
  <div class="row">
    <div class="label">Requests</div>
    <div class="val"><span id="r5s"></span> request<span id="r5splr">s</span> with greater than 5sec CPU time</div>
  </div>
</div>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

var svUrl = '<%= context.getURL() %>';
var attributes = <%= attributes %>;

function render(attributes) {
  for (var i in attributes) {
    var val = attributes[i];
    $("#" + i).text(val);
    if (val == 1) {
      $("#" + i + "sng").show();
      $("#" + i + "plr").hide();
    } else {
      $("#" + i + "sng").hide();
      $("#" + i + "plr").show();
    }
  }
}

function refresh() {
  var checked = $("input#refr:checked").length;
  if (checked == 1) {
    $.ajax({
      url: svUrl + "?cmd=admin-dashboard&mode=1",
      dataType: 'json',
      type: 'get',
      data: {},
      success: function(data) {
        render(data.attr);
      }
    });
    setTimeout(refresh, 2500);
  }
}

render(attributes);
refresh();
</script>

<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-cluster-status.jsp
// List/view cluster nodes
//
// ----------------------------------------------------------------------

message = context.getStringDelivery("Message");

vars.title = getTitle("Cluster Status");

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<style>
tr.thisnode td {
  color: rgb(0,120,80);
}
</style>

<h2>Cluster Status</h2>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td>ID</td>
  <td>Channel</td>
  <td>Name</td>
  <td>Connected</td>
  <td>Elapsed Time</td>
  <td>Messages Out</td>
  <td>Description</td>
</tr>
<tbody id="nodes">
</tbody>
</table>

<p id="thisnode"></p>

<%@ include file="include-custom-page-footer.jsp" %>

<script>

var svUrl = '<%= context.getURL() %>';
refresh();

function render(nodes, thisnode) {
  var c = "";

  nodes.sort(nodesById);
  for (var i in nodes) {
    c += "<tr" + (thisnode == nodes[i].id ? " class='thisnode'" : "") + "><td class='admconfitem' align='right'>" + nodes[i].id + "</td>";
    c += "<td class='admconfvalue'>" + nodes[i].ch + "</td>";
    c += "<td class='admconfvalue'>" + nodes[i].name + "</td>";
    c += "<td class='admconfvalue'>" + standardDateString(new Date(nodes[i].ct)) + "</td>";
    c += "<td class='admconfvalue'>" + nodes[i].het + " (" + nodes[i].et + " ms)</td>";
    c += "<td class='admconfvalue' align='right'>" + nodes[i].mc + "</td>";
    c += "<td class='admconfvalue'>" + nodes[i].desc + "</td></tr>";
  }

  $("#nodes").html(c);
  $("#thisnode").html("This is node ID " + thisnode + ".");
}

function nodesById(n1, n2) {
  return n1.id - n2.id;
}

function refresh() {
  $.ajax({
    url: svUrl + "?cmd=admin-cluster-status&mode=1",
    dataType: 'json',
    type: 'get',
    data: {},
    success: function(data) {
      render(data.nodes, data.thisnode);
    }
  });
}

</script>
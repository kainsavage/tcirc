<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-features.jsp
// View and toggle application Features
//
// ----------------------------------------------------------------------

Iterator<FeatureNode> iter = (Iterator<FeatureNode>)context.getDelivery("Roots");
String configuration = context.getStringDelivery("Config");

StringBuilder b = new StringBuilder(10000);
renderFeatures(b, iter);
String features = b.toString();

vars.title = getTitle("Application Features");

nav.add(new SimpleLink("Feature List", context.getCmdURL("admin-features")));

%><%!

void renderFeatures(StringBuilder b, Iterator<FeatureNode> nodes)
{
  FeatureNode node;
  while (nodes.hasNext())
  {
    node = nodes.next();
    boolean enabled = node.isEnabled();
    b.append("<div class=\"fn " + (enabled ? "enabled" : "disabled") + "\"><div class=\"fnn\">");
    b.append(node.getKey());
    b.append("</div><div class=\"fnd\">");
    b.append(node.getDescription());
    b.append("</div><div class=\"fnctrl\">");
    b.append("<a class=\"enable" + (enabled ? " sel" : "") + "\" href=\"javascript:enable('" + node.getKey() + "')\">Enable" + (enabled ? "d" : "") + "</a>");
    b.append("<a class=\"disable" + (enabled ? "" : " sel") + "\" href=\"javascript:disable('" + node.getKey() + "')\">Disable" + (enabled ? "" : "d") + "</a>");
    b.append("</div></div>");
    Iterator<FeatureNode> children = node.getChildren();
    if (children.hasNext())
    {
      b.append("<div class=\"fnc " + (enabled ? "enabled" : "disabled") + "\">");
      renderFeatures(b, children);
      b.append("</div>");
    }
  }
}

%><%@ include file="include-custom-page-header.jsp" %>
<style>

div.features
{
  width: 550px;
}

div.fn
{
  clear: both;
  border-bottom: 1px solid rgb(220,220,230);
  margin: 4px 0px 4px 0px;
}

div.fnn
{
  display: inline-block;
  font-weight: bold;
  margin-right: 10px;
  padding: 2px 0px 2px 0px;
}

div.fnc.disabled div.fnn
{
  text-decoration: line-through;
  color: rgb(130,130,140);
}

div.fnd
{
  display: inline;
}

div.fnc.disabled div.fnd
{
  text-decoration: line-through;
  color: rgb(130,130,140);
}

div.fnctrl
{
  float: right;
}

div.fnctrl a
{
  display: inline-block;
  margin: 0px 0px 0px 4px;
  padding: 2px 2px 2px 2px;
  text-decoration: none;
  color: black;
  text-align: center;
  width: 60px;
}

div.fnctrl a.enable
{
  background-color: rgb(200,200,250);
}

div.fnctrl a.enable.sel
{
  background-color: rgb(50,50,255);
  color: white;
  font-weight: bold;
}

div.fnc.disabled div.fnctrl a.enable
{
  background-color: rgb(240,240,255);
}

div.fnc.disabled div.fnctrl a.enable.sel
{
  background-color: rgb(190,190,255);
  color: white;
  font-weight: bold;
}

div.fnctrl a.disable
{
  background-color: rgb(250,200,200);
}

div.fnctrl a.disable.sel
{
  background-color: rgb(255,50,50);
  color: white;
  font-weight: bold;
}

div.fnc.disabled div.fnctrl a.disable
{
  background-color: rgb(255,240,240);
}

div.fnc.disabled div.fnctrl a.disable.sel
{
  background-color: rgb(255,190,190);
  color: white;
  font-weight: bold;
}

div.fnc
{
  padding-left: 20px;
}

textarea.config
{
  width: 550px;
  height: 100px;
  font-size: 14px;
  font-family: Consolas, Courier, Fixed;
}

</style>

<%@ include file="include-message.jsp" %>

<h2>Application Features</h2>

<div class="features">
<%= features %>
</div>

<% if (StringHelper.isNonEmpty(configuration)) { %>
<h2>Configuration</h2>

<p>The current configuration can be copied from the textarea below and
inserted into a configuration file.</p>

<textarea class="config"><%= configuration %></textarea>
<% } %>
<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

var svUrl = '<%= context.getURL() %>';

function toggle(state, feature) {
  var url = svUrl + "?cmd=admin-feature-state&" + state + "=" + feature;
  window.location = url;
}

function enable(feature) {
  toggle("enable", feature);
}

function disable(feature) {
  toggle("disable", feature);
}

</script>

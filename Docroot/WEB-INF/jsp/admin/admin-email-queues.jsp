<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-email-queues.jsp
// List outbound email queues
//
// ----------------------------------------------------------------------

EmailServicer servicer = context.getDelivery("EmailServicer");
EmailTransport transport = context.getDelivery("EmailTransport");
EmailDispatcher dispatcher = context.getDelivery("EmailDispatcher");

message = context.getStringDelivery("Message");

vars.title = getTitle("Email Statistics and Handlers");

nav.add(new SimpleLink(servicer.isPaused() ? "Resume outbound" : "Pause outbound", context.getCmdURL("admin-email-pause")));
if (dispatcher != null)
{
  nav.add(new SimpleLink(dispatcher.isPaused() ? "Resume inbound" : "Pause inbound", context.getCmdURL("admin-inbound-email-pause")));
  nav.add(new SimpleLink("Process inbound", context.getCmdURL("admin-inbound-email-immediate")));
}

int queued = servicer.getQueuedCount();
int sent = servicer.getSentCount();
int removed = servicer.getRemovedCount();
int pending = servicer.getPendingCount();
int senderThreads = servicer.getSenderThreadCount();
int peakThreads = servicer.getPeakSenderThreadCount();
int maxThreads = servicer.getMaximumSenderThreadCount();
boolean outPaused = servicer.isPaused();

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Outbound Email Statistics</h2>

<table border="0" cellpadding="0" cellspacing="0">
<% if (outPaused) { %>
<tr>
  <td class="admconfitem">Status:</td>
  <td class="admconfvalue">PAUSED [ <%= context.getCmdAnchor("admin-email-pause") %>Resume</a> ]</td>
</tr>
<% } %>
<tr>
  <td class="admconfitem">Queued:</td>
  <td class="admconfvalue"><%= queued %></td>
</tr>
<tr>
  <td class="admconfitem">Sent:</td>
  <td class="admconfvalue"><%= sent %></td>
</tr>
<tr>
  <td class="admconfitem">Removed:</td>
  <td class="admconfvalue"><%= removed %></td>
</tr>
<tr>
  <td class="admconfitem">Pending:</td>
  <td class="admconfvalue"><%= pending %> (queued but not yet sent or removed)</td>
</tr>
<tr>
  <td class="admconfitem">Threads:</td>
  <td class="admconfvalue"><%= senderThreads %> active; <%= peakThreads %> peak thread<%= StringHelper.pluralize(peakThreads) %> since application start-up; <%= maxThreads %> maximum permitted</td>
</tr>
</table>

<%
if (dispatcher != null)
{
  boolean inPaused = dispatcher.isPaused();
%>
<h2>Inbound Email</h2>

<p>[ <%= context.getCmdAnchor("admin-inbound-email-immediate") %>Process immediately</a> ]</p>

<table border="0" cellpadding="0" cellspacing="0">
<% if (inPaused) { %>
<tr>
  <td class="admconfitem">Status:</td>
  <td class="admconfvalue">PAUSED [ <%= context.getCmdAnchor("admin-inbound-email-pause") %>Resume</a> ]</td>
</tr>
<% } %>
<tr>
  <td class="admconfitem">Processed:</td>
  <td class="admconfvalue"><%= dispatcher.getTotalProcessed() %> inbound emails processed</td>
</tr>
<%
Iterator iter = dispatcher.getHandlers().iterator();
int handlerId = 0;
while (iter.hasNext())
{
  EmailHandler handler = (EmailHandler)iter.next();
%>
<tr>
  <td class="admconfitem">Handler <%= ++handlerId %>:</td>
  <td class="admconfvalue"><%= handler.toString() %></td>
</tr>
<% } %>
</table>
<% } %>

<h2>Configuration</h2>
<table border="0" cellpadding="0" cellspacing="0">
<tr>
  <td class="admconfitem">Outbound Servers:</td>
  <td class="admconfvalue"><%
  if (transport.getOutboundServers().length == 0)
  {
    %>(None)<%
  }
  EmailServerDescriptor d;
  for (int i = 0; i < transport.getOutboundServers().length; i++)
  {
    d = transport.getOutboundServers()[i];
    %><%= d.toString() %><br /><%
  }
  %></td>
</tr>
<tr>
  <td class="admconfitem">Inbound Servers:</td>
  <td class="admconfvalue"><%
  if (transport.getInboundServers().length == 0)
  {
    %>(None)<%
  }
  for (int i = 0; i < transport.getInboundServers().length; i++)
  {
    d = transport.getInboundServers()[i];
    %><%= d.toString() %><br /><%
  }
  %></td>
</tr>
<tr>
  <td class="admconfitem">Retry Limit:</td>
  <td class="admconfvalue"><%= transport.getRetryLimit() %></td>
</tr>
<tr>
  <td class="admconfitem">Delivery Domains:</td>
  <td class="admconfvalue"><%= (CollectionHelper.isEmpty(transport.getDeliveryDomains()) ? "(Not limited)" : transport.getDeliveryDomains()) %></td>
</tr>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

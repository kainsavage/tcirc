<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-event-list.jsp
// List scheduled events
//
// ----------------------------------------------------------------------

Iterator iter = (Iterator)context.getDelivery("Events");
long sleepTime = (Long)context.getDelivery("SleepTime");
Date nextCheck = (Date)context.getDelivery("NextCheck");

vars.title = getTitle("Scheduled Events");

nav.add(new SimpleLink("Event List", context.getCmdURL("admin-event-list")));

long uptime = app.getUptime();

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Scheduled Events</h2>

<table class="threadlist" border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td colspan="3">Event</td>
  <td>Status</td>
  <td>Last Run</td>
  <td>Duration</td>
  <td>Last Complete</td>
  <td>Next Run Time</td>
</tr>
<%
boolean f = false;
int id = 0;
Date now = new Date();
while (iter.hasNext())
{
  ScheduledEvent event = (ScheduledEvent)iter.next();
  Date eventDate = event.getScheduledTimeAsDate();

  long lastRunTime = event.getLastRunTime();
  long lastCompletion = event.getLastCompleteTime();
  long lastDuration = event.getLastRunDuration();

  String name;
  if (event.getName().equals(event.getDescription()))
  {
    name = event.getName();
  }
  else
  {
    name = "<abbr title='" + event.getDescription() + "'>" + event.getName() + "</abbr>";
  }

  %><tr>
  <td class="admconfitem"><%= name %></td>
  <td class="admconfitem" style="padding-left: 15px;">
    <a href="<%= context.getCmdURL("admin-event-run&id=" + id) %>">Run now</a>
  </td>
  <td class="admconfitem">
    <a href="<%= context.getCmdURL("admin-event-pause-resume&id=" + id) %>"><% 
    if (event.isEnabled()) { %>Disable<%
    } else { %>Enable<%
    } %></a>
  </td>
  <td class="admconfvalue<%= (event.isEnabled() ? "" : " paused") %>">
    <%= (event.isEnabled() ? "Enabled" : "Disabled") %>
  </td>
  <%
  if (event.isExecuting())
  {
    long sinceStart = System.currentTimeMillis() - lastRunTime;
    String executing;
    if (sinceStart > 0L)
    {
      executing = "( Executing for " + DateHelper.getHumanDuration(sinceStart, 1) + " ... )";
    }
    else
    {
      executing = "( Executing ... )";
    }
  %>
  <td class="admconfvalue" colspan="2" align="center"><%= executing %></tD>
  <%
  }
  else
  {
  %>
  <td class="admconfvalue"><%= (lastRunTime > 0L) ? (DateHelper.STANDARD_TECH_FORMAT.format(new Date(lastRunTime))) : "--" %></td>
  <td class="admconfvalue"><%= (lastDuration > 0L) ? (DateHelper.getHumanDuration(lastDuration, 1)) : "--" %></td>
  <%
  }
  %>
  <td class="admconfvalue"><%= (lastRunTime > 0L) ? (DateHelper.STANDARD_TECH_FORMAT.format(new Date(lastCompletion))) : "--" %></td>
  <td class="admconfvalue"><%= DateHelper.STANDARD_TECH_FORMAT.format(eventDate) %> (<%= DateHelper.getHumanDifference(now, eventDate, 2) %>)</td>
  </tr><%
  f = true;
  id++;
}
if (!f)
{
  %><tr><td class="admconfitem">(None)</td></tr><%
}
%>
<tr class="admsubheader">
  <td colspan="8">Configuration</td>
</tr>
<% if (nextCheck != null) { %>
<tr>
  <td class="admconfitem" colspan="1">Next check time</td>
  <td class="admconfvalue" colspan="7"><%= nextCheck %></td>
</tr>
<% } %>
<tr>
  <td class="admconfitem" colspan="1">Scheduler polling interval</td>
  <td class="admconfvalue" colspan="7"><%= sleepTime %> milliseconds</td>
</tr>
<tr>
  <td class="admconfitem" colspan="1">Application uptime</td>
  <td class="admconfvalue" colspan="7"><%= DateHelper.getHumanDuration(uptime, 2) %> (<%= uptime %> milliseconds)</td>
</tr>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

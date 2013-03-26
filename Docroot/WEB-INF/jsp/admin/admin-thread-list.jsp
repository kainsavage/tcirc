<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-thread-list.jsp
// List active threads
//
// ----------------------------------------------------------------------

Thread[] threads = (Thread[])context.getDelivery("ActiveThreads");
String threadDumpUrl = context.getStringDelivery("ThreadDumpUrl");
ThreadMXBean tmxb = (ThreadMXBean)context.getDelivery("TMXB");
GeminiMonitor monitor = (GeminiMonitor)context.getDelivery("Monitor");

vars.title = getTitle("Active Threads");

nav.add(new SimpleLink("Thread List", context.getCmdURL("admin-thread-list")));
if (StringHelper.isNonEmpty(threadDumpUrl))
{
  nav.add(new SimpleLink("Thread Dump", threadDumpUrl));
}

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Active Threads</h2>

<table border="0" cellpadding="0" cellspacing="0" class="threadlist">
<tr class="admheader">
  <td>Name</td>
  <td align="right">ID</td>
  <td align="right">Pr.</td>
  <td>Class name</td>
  <td>Run time</td>
  <% if (tmxb != null) { %><td>CPU</td>
  <% if (monitor != null) { %><td>Request CPU</td><% } } %>
  <td>Status</td>
  <td>Actions</td>
</tr>
<%
for (int i = 0; i < threads.length; i++)
{
  if (threads[i] != null)
  {
    String className = threads[i].getClass().getName();
    String simpleName = threads[i].getClass().getSimpleName();
    String name = threads[i].getName();
    String priorityName = "medpri";
    int priority = threads[i].getPriority();
    if (priority < 5)
    {
      priorityName = "lowpri";
    }
    else if (priority > 5)
    {
      priorityName = "highpri";
    }

    String stateStyle = "";
  
    Thread.State state = threads[i].getState();
    boolean endable = false;
  
    StringList flags = new StringList(", ");
  
    if (threads[i].isDaemon())
    {
      flags.add("Daemon");
    }
    if (threads[i] instanceof EndableThread)
    {
      EndableThread et = (EndableThread)threads[i];
      endable = true;
      if (et.isPaused())
      {
        if (et.isPauseChecked())
        {
          flags.add("Paused");
          stateStyle = "paused";
        }
        else
        {
          flags.add("Pause pending");
          stateStyle = "pausepending";
        }
      }
      else
      {
        flags.add("Running");
      }
    }
    if (!endable)
    {
      if (state == Thread.State.NEW)
      {
        flags.add("New");
      }
      else if (state == Thread.State.RUNNABLE)
      {
        flags.add("Running");
      }
      else if (state == Thread.State.BLOCKED)
      {
        flags.add("Blocked");
      }
      else if (state == Thread.State.WAITING)
      {
        flags.add("Waiting");
      }
      else if (state == Thread.State.TIMED_WAITING)
      {
        flags.add("Timed-Waiting");
      }
      else if (state == Thread.State.TERMINATED)
      {
        flags.add("Terminated");
      }
    }

  %><tr>
  <td class="admconfitem"><%= name %></td>
  <td class="admconfvalue" align="right"><%= threads[i].getId() %></td>
  <td class="admconfvalue <%= priorityName %>" align="right"><%= priority %></td>
  <td class="admconfvalue"><abbr title="<%= render(className) %>"><%= simpleName %></abbr></td>
<%
    if (endable)
    {
    %><td class="admconfvalue admnowrap"><%= (DateHelper.getHumanDuration(((EndableThread)threads[i]).getThreadLifetime(), 1)) %></td><%
    } else {
    %><td class="admconfvalue admnowrap">--</td><%
    }
    if (tmxb != null)
    {
      long cputime = tmxb.getThreadCpuTime(threads[i].getId());
      // Convert to ms.
      long cpums = cputime / 1000000L;
      if (cpums > 1000L)
      {
        %><td class="admconfvalue admnowrap"><%= (DateHelper.getHumanDuration(cpums, 1)) %></td><%
      }
      else
      {
        %><td class="admconfvalue admnowrap">--</td><%
      }
      if (monitor != null)
      {
        MonitorSample sample = monitor.getRequest(threads[i].getId());
        if (sample != null)
        {
          %><td class="admconfvalue admnowrap"><%= (DateHelper.getHumanDuration(sample.getTotalCpuTimeInProgress(), 1)) %></td><%
        }
        else
        {
          %><td class="admconfvalue admnowrap">--</td><%
        }
      }
    }
%>
  <td class="admconfvalue admnowrap <%= stateStyle %>"><%= flags.toString() %></td>
  <td class="admconfvalue">
    <a href="<%= context.getCmdURL("admin-thread-view&id=" + threads[i].getId()) %>">View</a>&nbsp;<a
       href="<%= context.getCmdURL("admin-thread-interrupt&id=" + threads[i].getId()) %>">Interrupt</a><%
    if (endable)
    {
      EndableThread et = (EndableThread)threads[i];
      if (et.isPaused())
      {
        %>&nbsp;<a href="<%= context.getCmdURL("admin-thread-pause&id=" + threads[i].getId()) %>">Resume</a><%
      }
      else
      {
        %>&nbsp;<a href="<%= context.getCmdURL("admin-thread-pause&pause=1&id=" + threads[i].getId()) %>">Pause</a><%
      }
      %>&nbsp;<a href="<%= context.getCmdURL("admin-thread-end&id=" + threads[i].getId()) %>">End</a><%
    }
%>
  </td>
<%
  }
}
%>

</table>

<p>
Note that pausing EndableThread subclasses will not necessarily or immediately pause their execution.  Execution will only be paused on the thread's next invocation of the checkPause() method.
</p>

<%@ include file="include-custom-page-footer.jsp" %>

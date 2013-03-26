<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-thread-view.jsp
// View a thread
//
// ----------------------------------------------------------------------

Thread thread = (Thread)context.getDelivery("Thread");
StackTraceElement[] trace = (StackTraceElement[])context.getDelivery("Trace");
long cputime = (Long)context.getDelivery("ns");

String cpu = "";
if (cputime > 0L)
{
  cpu = " with " + cputime + " ns (" + (cputime / 1000000L) + " ms) of CPU time";
}

vars.title = getTitle("View Thread #" + thread.getId());

nav.add(new SimpleLink("Thread List", context.getCmdURL("admin-thread-list")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Thread #<%= thread.getId() %> (<%= thread.getName() %>)</h2>

<p><%= thread.toString() %></p>

<%
int priority = thread.getPriority();
if (priority < 5) {
%>
<p>Low (level <%= priority %>) priority<%= cpu %>.</p>
<%
} else if (priority == 5) {
%>
<p>Normal (level <%= priority %>) priority<%= cpu %>.</p>
<%
} else {
%>
<p>High (level <%= priority %>) priority<%= cpu %>.</p>
<%
}
%>

<table border="0" cellpadding="0" cellspacing="0">
<tr class="admheader">
  <td>#</td>
  <td>Trace</td>
</tr>
<%
for (int i = 0; i < trace.length; i++)
{
  %><tr>
  <td class="admconfitem"><%= i %></td>
  <td class="admconfvalue"><%= trace[i].getClassName() %>.<%= trace[i].getMethodName() %> (<%= trace[i].getFileName() %>:<%= trace[i].getLineNumber() %>)</td>
  </tr>
<%
}
%>

</table>

<%@ include file="include-custom-page-footer.jsp" %>

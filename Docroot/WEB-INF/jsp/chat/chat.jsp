<%@ page extends="net.teamclerks.tcirc.TCJsp" %><%@ include file="/WEB-INF/jsp/include-variables.jsp" %><%

  // -----------------------------------------------------------------
  // Chat page
  //
  // author: kain
  // -----------------------------------------------------------------

  vars.title = "TCIRC - Chat";

  vars.sas.addSheet("tc.chat.css");
  vars.sas.addScript("tc.chat.js");
  
%><%@ include file="/WEB-INF/jsp/include-page-start.jsp" %>

<h2><%= context.getSessionValue("channel") %></h2>

<div id="chatters"><ul>
</ul></div>
<table id="chat">
<tbody>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
  <tr><td class="time">&nbsp;</td><td class="who">&nbsp;</td><td class="text">&nbsp;</td></tr>
</tbody>
</table>

<textarea id="chatInput"></textarea>

<%@ include file="/WEB-INF/jsp/include-page-end.jsp" %>
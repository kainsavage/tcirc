<%@ page extends="net.teamclerks.tcirc.TCJsp" %><%@ include file="/WEB-INF/jsp/include-variables.jsp" %><%

  // -----------------------------------------------------------------
  // About page
  //
  // author: kain
  // -----------------------------------------------------------------

  vars.title = "TCIRC About";

%><%@ include file="/WEB-INF/jsp/include-page-start.jsp" %>

<h2>About TeamClerks IRC</h2>

<p>
The TeamClerks IRC web application was built by me, kain. Originally, 
I was using a number of different clients which all had some aspects 
that I liked, but ultimately fell short in terms of what they provided 
me.
<p>
For instance, I had originally been using Trillian's IRC client, but 
I found myself annoyed by the fact that I had to either allow Trillian
to alert me when a channel received a message at all (which would 
cause a rather loud beep; I turned that off but would still put a pop-
up in the bottom corner of my screen alerting me that someone had said
ANYTHING at all) or keep the chat window constantly on one screen so
that I could see something change and look over to see if it was
important or not.
<p>
Then, I started using web-clients, like 
<a href="www.mibbit.com">Mibbit</a>. What I disliked about Mibbit was
very minor, but it led me to writing my own. When anything happens in
Mibbit, it changes the title of the page (if it is out of focus) to
"[New Message!]", which would cause the tab to turn blue (in Firefox)
if it were pinned as an "app tab". I <b>LOVED</b> this idea, but found
the design lacking, since the title of the page would ALSO change if
you selected a different tab. This defeated the implementation entirely.
<p>
So, here we are with my web client implementation with alerts for app
tabs. It is simple, it is ugly, and it gets the job done. Hopefully,
you are enjoying the experience, but feel free to contact me if you have
any suggestions/questions/bugs.   

<%@ include file="/WEB-INF/jsp/include-page-end.jsp" %>
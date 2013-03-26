<!DOCTYPE html>
<head>
  <title><%= render(vars.title) %></title>
  <!--[if lt IE 9]><script src="<%= renderJavaScriptPath(context, "html5.js") %>"></script><![endif]-->
  <%= renderSheets(context, vars.sas) %>
</head>
<body<% if (StringHelper.isNonEmpty(vars.onload)) { %> onload="<%= vars.onload %>"<% } %>>
  <div id="container">
    <header id="header">
      TeamClerks IRC
    </header>
    <div id="content">
    <div id="messages"><%= renderMessages(context) %></div>
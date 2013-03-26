<%@ page import="net.teamclerks.tcirc.*,
                 net.teamclerks.tcirc.accounts.entity.*,
                 net.teamclerks.tcirc.accounts.handler.*" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/include-custom-page-header.jsp
// Use this file to import any necessary custom packages, set up custom
// variables, and render a custom page header.
//
// ----------------------------------------------------------------------
//
// Relevant variables provided by the containing page:
//
//    RequestVariables vars
//
// ----------------------------------------------------------------------

// Custom variables below.

String      sectionName = "admin";
User        currentUser = (User)currentAdmin;
GeminiApplication gemApp = app;

boolean     isAdministrator = (currentUser != null) && (currentUser.isAdministrator());

%>
<%@ include file="../include-page-start.jsp" %>
<%@ include file="include-subnav.jsp" %>
<div id="admcontent">
<%@ page import="com.techempower.*,
                 com.techempower.gemini.*,
                 com.techempower.gemini.form.*,
                 com.techempower.gemini.messaging.*,
                 com.techempower.gemini.jsp.*,
                 com.techempower.helper.*,
                 net.teamclerks.tcirc.*,
                 net.teamclerks.tcirc.accounts.entity.*,
                 java.math.*,
                 java.text.*,
                 java.util.*" %><%

  //
  // Sets up variables for use on all JSP pages.
  //

  TCContext          context  = (TCContext)request.getAttribute("Context");
  TCRequestVariables vars     = new TCRequestVariables(context);

  // Note that default stylesheets and scripts that are to be included on
  // -all- pages should be defined in TCInfrastructure's
  // constructor.  Page-scope stylesheets and scripts should be defined by
  // overloading the jspInit function to call sas.addScript and sas.addSheet.
  // Request-scope scripts and sheets can be defined by using vars.sas.
  // However, request-scope scripts and sheets are quite uncommon.

%>
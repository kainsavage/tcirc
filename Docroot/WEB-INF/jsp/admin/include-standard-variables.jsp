<%@ page import="java.util.*,
                 java.lang.management.*,
                 com.techempower.*,
                 com.techempower.data.*,
                 com.techempower.data.util.*,
                 com.techempower.helper.*,
                 com.techempower.util.*,
                 com.techempower.gemini.*,
                 com.techempower.gemini.feature.*,
                 com.techempower.gemini.monitor.*,
                 com.techempower.gemini.monitor.cpupercentage.*,
                 com.techempower.gemini.monitor.session.*,
                 com.techempower.gemini.form.*,
                 com.techempower.gemini.email.*,
                 com.techempower.gemini.email.outbound.*,
                 com.techempower.gemini.email.inbound.*,
                 com.techempower.gemini.jsp.*,
                 com.techempower.gemini.session.*,
                 com.techempower.gemini.pyxis.*,
                 com.techempower.gemini.admin.*,
                 com.techempower.js.*,
                 com.techempower.cache.*,
                 com.techempower.log.*,
                 com.techempower.scheduler.*,
                 com.techempower.thread.*"
%><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/include-standard-variables.jsp
// Sets up standard variables for use within administrative web pages.
//
// ----------------------------------------------------------------------

Context           context      = (Context)request.getAttribute("Context");
RequestVariables  vars         = new RequestVariables(context);
GeminiApplication app          = context.getApplication();
CacheController   cache        = app.getCache();
Infrastructure    inf          = app.getInfrastructure();
String            imgDir       = inf.getImageDirectory(context);
String            cssDir       = inf.getCssDirectory(context);
String            jsDir        = inf.getJavaScriptDirectory(context);

PyxisApplication  pyxisApp     = (PyxisApplication)app;
PyxisSecurity     security     = pyxisApp.getSecurity();
PyxisUser         currentAdmin = security.getUser(context);

// Default values for common provided variables.
vars.title        = "Administration";
String            onload       = "";
String            message      = context.getStringDelivery("Message", "");

// Navigation items for rendering into a navigation structure.  The
// list contains SimpleLink objects.
ArrayList<SimpleLink> nav = new ArrayList<SimpleLink>();
nav.add(new SimpleLink("Admin Menu", context.getCmdURL(BasicAdminHandler.CMD_MENU)));

%>
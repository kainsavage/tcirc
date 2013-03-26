/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 */
package net.teamclerks.tcirc.admin;

import net.teamclerks.tcirc.*;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.techempower.gemini.*;

/**
 * Provides application-specific JSP functionality for the Basic
 * Administration section's JSP files.
 * 
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public abstract class TCAdminJsp
  extends             TCJsp
{

  private Dispatcher        dispatcher;

  /* (non-Javadoc)
   * @see com.techempower.gemini.jsp.InfrastructureJsp#setApplication(com.techempower.gemini.GeminiApplication)
   */
  @Override
  protected synchronized void setApplication(GeminiApplication application)
  {
    super.setApplication(application);
    this.dispatcher = application.getDispatcher();
  }

  /**
   * Initialize page-scope JavaScript and CSS style-sheet references in the 
   * "sas" variable.
   */
  @Override
  protected void initSas()
  {
    super.initSas();
    
    // Include the standard Basic Administration site JavaScript and CSS.
    getSas().addSheet("basicadmin.css");
    getSas().addScript("basicadmin.js");

    // The Admin section requires JQuery so we'll add that here.
    getSas().addScript("jquery.js");
  }

  /**
   * This is not final so it can be overridden by a more precise
   * method.
   */
  @Override
  public String getServletInfo()
  {
    return "BasicAdmin JSP";
  }

  /**
   * The entry point into service.
   */
  @Override
  public void service(ServletRequest req, ServletResponse res)
    throws ServletException, IOException
  {
    // casting exceptions will be raised if an internal error.
    HttpServletRequest  request  = (HttpServletRequest)req;
    HttpServletResponse response = (HttpServletResponse)res;

    // See if the context is available.  If not, this JSP was invoked
    // directly.
    Context context = (Context)request.getAttribute("Context");

    // Context will be null if the JSP was invoked directly.
    if (context != null)
    {
      // Get a reference to the application and log.
      if (getApplication() == null)
      {
        setApplication(context.getApplication());
      }
      
      try
      {
        // Proceed normally.
        _jspService(request, response);
      }
      catch (Exception exc)
      {
        // Ask the dispatcher to handle this exception.
        this.dispatcher.dispatchException(context, exc, "Admin page error");
      }
    }
    else
    {
      // If the context is null, this request came to the JSP directly.
      // Redirect to the site's home.
      //response.sendError(404);
      response.sendRedirect("/");
    }
  }
  
  /**
   * Generates a title for a page. 
   */
  public String getTitle(String title)
  {
    return title + " - " + getApplication()   .getVersion().getProductName() 
      + " Administration";
  }
  
}

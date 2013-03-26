/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import com.techempower.gemini.*;

/**
 * A special version of Context that provides TCIRC-specific
 * functionality.
 *
 * @see com.techempower.gemini.Context
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCContext
     extends Context
{

  //
  // Member variables.
  //

  //
  // Member methods.
  //

  /**
   * Standard constructor.
   *
   * @param request the Request object received by the servlet.
   * @param response the Response object received by the servlet.
   * @param servletContext the ServletContext the servlet is running within.
   * @param application the application.
   */
  public TCContext(Request request,
      GeminiApplication application)
  {
    super(request, application);
  }

  /**
   * @see com.techempower.gemini.Context.getApplication()
   */
  @Override
  public TCApplication getApplication()
  {
    return (TCApplication)super.getApplication();
  }

}   // End TCContext.


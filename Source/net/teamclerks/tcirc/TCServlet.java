/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import javax.servlet.annotation.*;
import com.techempower.gemini.*;

/**
 * Main Servlet to be used by the TCIRC application.  Upon
 * receiving a request, this Servlet creates a Context object and
 * then invokes the Dispatcher.  The Dispatcher determines what happens
 * next.
 *
 * @see com.techempower.gemini.InfrastructureServlet
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
@SuppressWarnings("serial")
@WebServlet(name="TC", urlPatterns="*")
public class TCServlet
     extends InfrastructureServlet
{

  //
  // Public member methods.
  //

  /**
   * Handles the init call.  Starts the Infrastructure.  This method -must-
   * call super.init().
   */
  @Override
  public void init()
  {
  	// Do not remove the super.init() call below.
    super.init();

    // Additional initialization is optional.
  }

  /**
   * Gets a GeminiApplication object for this application.
   */
  @Override
  public TCApplication getApplication()
  {
    return TCApplication.getInstance();
  }

  /**
   * Handles the destroy call.  This method -must- call super.destroy().
   */
  @Override
  public void destroy()
  {
  	// Do not remove the super.destroy() call below.
    super.destroy();

    // Additional clean-up is optional.
  }

}   // End TCServlet.


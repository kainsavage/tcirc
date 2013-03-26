/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc.accounts.handler;

import net.teamclerks.tcirc.*;
import com.techempower.gemini.form.*;
import com.techempower.gemini.pyxis.*;

/**
 * Handles login and logout requests.  This is TCIRC's
 * implementation of Gemini's BasicLoginHandler.
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class LoginHandler 
     extends BasicLoginHandler<TCDispatcher, TCContext>
{
  /**
   * Constructor.
   */
  public LoginHandler(TCApplication application)
  {
    super(application, null);
  }

  @Override
  protected void postLoginProcessing(TCContext context)
  {
    // Custom logic after a successful login.
  }

  @Override
  protected void preLoginProcessing(TCContext context, Form loginForm)
  {
    // Custom logic prior to a user's first login attempt.
  }

  @Override
  protected boolean handleLogoutNoUser(TCDispatcher dispatcher,
      TCContext context, String command)
  {
    // This is what happens when a user attempts to log out while not 
    // being logged in first.  
    
    // Display the logout page instead of an error message.
    //return context.includeJSP("accounts/logout.jsp");
    
    // Display an error message.
    return super.handleLogoutNoUser(dispatcher, context, command);
  }

  @Override
  protected boolean handlePostLogout(TCDispatcher dispatcher,
      TCContext context, String command)
  {
    // Custom logic after a user logs out.
    
    // Clear the session.
    //context.removeAllSessionValues();
    
    return super.handlePostLogout(dispatcher, context, command);
  }

} // End LoginHandler.

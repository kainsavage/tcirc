/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import net.teamclerks.tcirc.accounts.handler.LoginHandler;
import net.teamclerks.tcirc.admin.handler.TCGeminiAdminHandler;
import net.teamclerks.tcirc.chat.handler.ChatHandler;
import net.teamclerks.tcirc.home.handler.AboutHandler;
import net.teamclerks.tcirc.home.handler.HomeHandler;

import com.techempower.gemini.BasicDispatcher;
import com.techempower.gemini.GeminiApplication;
import com.techempower.gemini.exceptionhandler.BasicExceptionHandler;
import com.techempower.gemini.exceptionhandler.EmailExceptionHandler;
import com.techempower.gemini.handler.MaintenanceHandler;
import com.techempower.gemini.handler.ThreadDumpHandler;

/**
 * Provides the dispatching functionality to the TCIRC application.
 *
 * @see com.techempower.gemini.Dispatcher
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCDispatcher
     extends BasicDispatcher
{
  //
  // Member variables.
  //

  //
  // Member methods.
  //

  /**
   * Constructor.
   *
   * @param application the GeminiApplication reference.
   */
  public TCDispatcher(GeminiApplication application)
  {
    // Call the super-class constructor.
    super(application);
  }

  /**
   * Initialize and add the handlers.
   */
  @Override
  protected void installHandlers()
  {
    TCApplication app = (TCApplication)this.getApplication();
    
    // Add Handlers.  The order of Handlers is important; Handlers added
    // first will get an earlier crack at handling requests.

    // Add the maintenance handler for enabling maintenance mode.
    addHandler(MaintenanceHandler.DEFAULT_ROLE_NAME, 
        new MaintenanceHandler<TCDispatcher, TCContext>(app));

    // Add the LoginHandler in the "login" role (for lookup by
    // subclasses of SecureHandler).
    LoginHandler loginHandler = new LoginHandler(app);
    addHandler("login", loginHandler);
    
    addHandler(new HomeHandler(app));
    addHandler(new ChatHandler(app));
    addHandler(new AboutHandler(app));

    // Add a password reset handler.
    //addHandler(new PasswordResetHandler(app));

    // Add your application-specific Handlers here.

    // Add the two normal Exception Handlers: one for displaying
    // an error to the user and another for e-mailing system
    // administrators in the event of an exception.
    addExceptionHandler(new BasicExceptionHandler(app));
    addExceptionHandler(new EmailExceptionHandler(app));

    // --------------------------------------------------------------------
    // Gemini administrative tools

    // Standard Gemini system administration functionality.
    TCGeminiAdminHandler adminHandler = new TCGeminiAdminHandler(app);
    addHandler(adminHandler);

    // Enable the performance monitor.
    addListener(app.getMonitor().getListener());

    // Enable the thread dump handler.
    addHandler("threaddump", new ThreadDumpHandler(app));
    // --------------------------------------------------------------------

    // Prehandlers
    //addPrehandler(new SomePrehandler(app));

    // Other TCIRC-specific handlers.
    //addHandler(new SomeHandler(app));
  }
  
  /* Un-comment the following to enable Auditing functionality.  See the
   * Wiki for instructions on additional Auditing prerequisites.
   */

  /*
  @Override
  public boolean dispatch(Context context)
  {
    TCApplication application = (TCApplication)this.application;

    try
    {
      if (AuditManager.size() == 0)
      {
        User user = application.getSecurity().getUser(context);
        application.getAuditManager().newSession(user);
      }

      return super.dispatch(context);
    }
    finally
    {
      AuditManager.commit();
    }
  }
  */

}   // End TCDispatcher.

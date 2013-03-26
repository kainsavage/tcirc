/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc.admin.handler;

import net.teamclerks.tcirc.accounts.entity.Group;
import net.teamclerks.tcirc.accounts.entity.User;

import com.techempower.gemini.GeminiApplication;
import com.techempower.gemini.admin.BasicAdminHandler;
import com.techempower.gemini.admin.logmonitor.LogMonitor;
import com.techempower.gemini.admin.logmonitor.LogMonitorChannel;
import com.techempower.gemini.admin.standard.cache.CacheCategory;
import com.techempower.gemini.admin.standard.config.ConfigurationCategory;
import com.techempower.gemini.admin.standard.email.EmailCategory;
import com.techempower.gemini.admin.standard.monitor.MonitorCategory;
import com.techempower.gemini.admin.standard.system.SystemCategory;
import com.techempower.log.LogLevel;

/**
 * TCGeminiAdminHandler is TCIRC's implementation of Gemini's
 * basic admin handler.  This is not the place for any old admin-related
 * commands.
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCGeminiAdminHandler
     extends BasicAdminHandler
{

  //
  // Constants.
  //

  // An example of custom user list columns:
  /*
  ReflectiveListColumn[] CUSTOM_USER_LIST_COLUMNS = ReflectiveListColumn.constructArray(
  new String[] { "getFavoriteColor", "Favorite Color", "--"
               }
  );
  */

  //
  // Member variables.
  //

  //private TCCache cache;

  //
  // Member methods.
  //

  /**
   * Constructor.
   */
  public TCGeminiAdminHandler(GeminiApplication application)
  {
    super(application, null, User.class, Group.class);
    //this.cache = (TCCache)application.getStore();

    // User management.
    addFunctionCategory(new TCUserCategory());

    // Email.
    addFunctionCategory(new EmailCategory());

    // Configuration.
    addFunctionCategory(new ConfigurationCategory());
    
    // Monitoring.
    addFunctionCategory(new MonitorCategory());
    
    // Cache relations.
    addFunctionCategory(new CacheCategory());
    
    // System management.
    addFunctionCategory(new SystemCategory());

    // Enable the log monitor.
    LogMonitor logMonitor = new LogMonitor(application, null);
    logMonitor.addChannel(new LogMonitorChannel("All", LogLevel.MINIMUM, LogLevel.MAXIMUM, null));
    logMonitor.addChannel(new LogMonitorChannel("Notice and above", LogLevel.NOTICE, LogLevel.MAXIMUM, null));
    addFunction(logMonitor);
  }

}   // End AdminHandler.


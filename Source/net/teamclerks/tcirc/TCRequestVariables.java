/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import com.techempower.gemini.jsp.*;

import net.teamclerks.tcirc.accounts.entity.*;

/**
 * Common request-scope variables available within JSPs in 
 * TCIRC.
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCRequestVariables
  extends    RequestVariables
{
  /**
   * The current context.
   */
  public final TCContext context;

  /**
   * The currently logged-in user.
   */
  public final User user;

  /**
   * Whether the current user is an administrator.
   */
  public final boolean isAdministrator;

  /**
   * Creates a new page variables object for the given context.
   */
  public TCRequestVariables(TCContext context)
  {
    super(context);
    this.context = context;
    this.user = context.getApplication().getSecurity().getUser(context);
    this.isAdministrator = (this.user != null && this.user.isAdministrator());
    this.title = "TCIRC";
  }
}

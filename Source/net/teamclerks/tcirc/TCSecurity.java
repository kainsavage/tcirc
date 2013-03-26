/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import net.teamclerks.tcirc.accounts.entity.*;

import com.techempower.gemini.*;
import com.techempower.gemini.pyxis.*;

/**
 * TCSecurity provides Pyxis-based security services for the
 * TCIRC application.
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCSecurity
     extends BasicSecurity<User, Group>
{

  //
  // Member methods.
  //

  /**
   * Constructor.
   */
  public TCSecurity(GeminiApplication application)
  {
    super(application, User.class, Group.class);
  }
  
  /**
   * Constructs a PyxisUser object or a subclass thereof.  Applications
   * should overload this method to return an instance of a BasicUser
   * subclass.
   */
  @Override
  public User constructUser()
  {
    return new User(this);
  }

  /**
   * Gets the logged-in user from the Context's session.  Returns null
   * if no user is logged in.
   *
   * @param Context the Context from which to retrieve a user.
   */
  @Override
  public User getUser(Context context)
  {
    return (User)super.getUser(context);
  }

}   // End TCSecurity.

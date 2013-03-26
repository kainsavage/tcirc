/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc.accounts.entity;

import com.techempower.gemini.pyxis.*;

/**
 * Represents a User of the TCIRC application.  Based on Pyxis'
 * BasicWebUser.
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class User
     extends BasicWebUser
{

  //
  // Member variables.
  //

  //
  // Member methods.
  //

  /**
   * Constructor.
   */
  public User(BasicSecurity<User, Group> security)
  {
    super(security);
  }

}   // End User.

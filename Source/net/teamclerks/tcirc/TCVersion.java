/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import com.techempower.*;
import com.techempower.gemini.*;
import com.techempower.helper.*;

/**
 * Contains simple constants regarding the name, client, version number,
 * etc. of the current build of the TCIRC application.
 *
 * @see com.techempower.Version
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCVersion
     extends Version
  implements GeminiConstants
{

  //
  // Member methods.
  //

  /**
   * Constructor.  This builds the version string.
   */
  public TCVersion()
  {
    this.setVersionString(getMajorVersion() + "." 
        + StringHelper.padZero(getMinorVersion(), 2)
        + "(" + StringHelper.padZero(getMicroVersion(), 2) 
        + ") (Gemini " + GEMINI_VERSION + ")");
  }

  /**
   * Get the version levels.
   */
  @Override
  public int getMajorVersion()  { return 0; }
  @Override
  public int getMinorVersion()  { return 1; }
  @Override
  public int getMicroVersion()  { return 0; }

  /**
   * Gets the product code.
   */
  @Override
  public String getProductCode()
  {
    return "TC";
  }

  /**
   * Gets the product name.
   */
  @Override
  public String getProductName()
  {
    return "TCIRC";
  }

  /**
   * Gets the client's name.
   */
  @Override
  public String getClientName()
  {
    return "TechEmpower, Inc.";
  }

  /**
   * Gets the developer's name.
   */
  @Override
  public String getDeveloperName()
  {
    return "TechEmpower, Inc.";
  }

  /**
   * Gets the copyright years.
   */
  @Override
  public String getCopyrightYears()
  {
    return "2013";
  }

}   // End TCVersion.


/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import com.techempower.gemini.*;
import com.techempower.util.*;

/**
 * A custom Configurator for TCIRC.
 *
 * @see com.techempower.gemini.Configurator
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCConfigurator
     extends Configurator
{
  //
  // Protected methods.
  //

  /**
   * Constructor.
   */
  protected TCConfigurator(GeminiApplication application)
  {
    super(application);
  }

  //
  // Member methods.
  //

  /**
   * Performs custom configuration for TCIRC.
   */
  @Override
  protected void customConfiguration(EnhancedProperties props)
  {
    // No custom configuration behavior.
  }

}   // End TCConfigurator.


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
 * Provides the dispatching functionality to the TCIRC application.
 *
 * @see com.techempower.gemini.Dispatcher
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCUrlRewriter
     extends PrettyUrlRewriter
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
  public TCUrlRewriter(TCApplication application)
  {
    // Call the super-class constructor.
    super(application);
  }

  /**
   * Add your url rules
   */
  @Override
  protected void installRules()
  {
    // Examples:
    // this.addRule("Articles/(?<foo>\\d+)/(?<author>[a-zA-Z]+)", "article-list-author");
    // this.addRule("Articles/(?<foo>\\d+)", "article-list");
  }

}   // End TCUrlRewriter.
/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc.home.handler;

import net.teamclerks.tcirc.*;
import com.techempower.gemini.annotation.*;
import com.techempower.gemini.annotation.response.*;
import com.techempower.util.*;

/**
 * Handles requests for robots.txt.  Allows the file served as robots.txt to be
 * configurable.  Has an external dependency that requests for /robots.txt are
 * forwarded to /?cmd=robots.
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class RobotsHandler
     extends TCHandler
  implements Configurable
{
  private String robotsFile = "robots.txt";

  /**
   * Constructor.
   */
  public RobotsHandler(TCApplication application)
  {
    super(application);
    application.getConfigurator().addConfigurable(this);
  }

  /**
   * Configure this component.
   */
  @Override
  public void configure(EnhancedProperties props)
  {
    this.robotsFile = props.getProperty("Robots.File", this.robotsFile);
  }

  /**
   * Renders a robots.txt.
   */
  @CMD("robots")
  @TossFile(asAttachment=false)
  public String handleRobots(TCContext context)
  {
    return robotsFile;
  }
}

/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

/**
 * Base class for TCIRC handlers.  Uses the &#064;CMD("command-name") annotation
 * for commands.
 *
 * Development history:
 *   2013-01-24 - ks - Class created
 *
 * @author (author)
 */
public abstract class TCHandler
{

  //
  // Member variables.
  //

  private final TCApplication    application;
  private final TCCache          cache;
  private final TCInfrastructure infrastructure;
  private final TCSecurity       security;
  
  //
  // Member methods.
  //

  /**
   * Constructor.
   */
  public TCHandler(TCApplication application)
  {
    this.application = application;
    this.cache = (TCCache)application.getStore();
    this.infrastructure = application.getInfrastructure();
    this.security = application.getSecurity();
  }
  
  /**
   * Gets the Application reference.
   */
  protected TCApplication getApplication()
  {
    return this.application;
  }

  /**
   * Gets the Cache reference.
   */
  protected TCCache getCache()
  {
    return this.cache;
  }
  
  /**
   * Gets the Infrastructure reference.
   */
  protected TCInfrastructure getInfrastructure()
  {
    return this.infrastructure;
  }
  
  /**
   * Gets the Security reference.
   */
  protected TCSecurity getSecurity()
  {
    return this.security;
  }
  
}  // End TCHandler.
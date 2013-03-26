/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import com.techempower.util.*;

/**
 * The base class for all data entities in TCIRC.  This class provides
 * the implementation of the Identifiable interface so that sub-classes
 * only need to provide member variables and typical get/set methods.
 *
 * Development history:
 *   2013-01-24 - ks - Class created
 *
 * @author kain
 */
public abstract class TCDataEntity
           implements Identifiable
{
  /**
   * The identity for this object.
   */
  private int id;

  @Override
  public int getId()
  {
    return this.id;
  }

  @Override
  public void setId(int newIdentity)
  {
    this.id = newIdentity;
  }

  @Override
  public String toString()
  {
    return getClass().getSimpleName() + "[" + getId() + "]";
  }

}   // End TCDataEntity.

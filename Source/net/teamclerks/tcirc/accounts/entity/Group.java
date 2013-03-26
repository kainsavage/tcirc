/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc.accounts.entity;

import net.teamclerks.tcirc.*;
import com.techempower.gemini.pyxis.*;

/**
 * Represents a user group for the TCIRC application.
 *
 * @author kain
 *
 * Development history:
 *   2013-01-24 - ks - Created
 */
public class Group
     extends TCDataEntity
  implements PyxisUserGroup
{

  //
  // Member variables.
  //

  private String name;               // 50 chars
  private String description;        // 100 chars
  private int    type;

  //
  // Member methods.
  //

  /**
   * Alias for getId(), required by PyxisUserGroup.
   */
  @Override
  public int getGroupID()
  {
    return getId();
  }

  /**
   * Alias for setId(int), required by PyxisUserGroup.
   */
  @Override
  public void setGroupID(int groupID)
  {
    setId(groupID);
  }

  /**
   * @see com.techempower.gemini.pyxisPyxisUserGroup#getDescription()
   */
  @Override
  public String getDescription()
  {
    return this.description;
  }

  /**
   * @see com.techempower.gemini.pyxisPyxisUserGroup#setDescription(String)
   */
  @Override
  public void setDescription(String description)
  {
    this.description = description;
  }

  /**
   * @see com.techempower.gemini.pyxisPyxisUserGroup#getName()
   */
  @Override
  public String getName()
  {
    return this.name;
  }

  /**
   * @see com.techempower.gemini.pyxisPyxisUserGroup#setName(String)
   */
  @Override
  public void setName(String name)
  {
    this.name = name;
  }

  /**
   * @see com.techempower.gemini.pyxisPyxisUserGroup#getType()
   */
  @Override
  public int getType()
  {
    return this.type;
  }

  /**
   * @see com.techempower.gemini.pyxisPyxisUserGroup#setType(int)
   */
  @Override
  public void setType(int type)
  {
    this.type = type;
  }

}   // End Group.

/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import net.teamclerks.tcirc.accounts.entity.*;

import com.techempower.*;
import com.techempower.cache.*;
import com.techempower.data.*;
import com.techempower.gemini.cluster.client.handler.*;
import com.techempower.log.*;

/**
 * TCCache provides simple data entity caching services.
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCCache
     extends EntityStore
{
  //
  // Member variables.
  //

  /**
   * Map of users to groups.
   */
  //private CachedRelation<User, Group> mapUserToGroup;

  //
  // Member methods.
  //

  /**
   * Constructor.
   */
  public TCCache(TechEmpowerApplication application, ConnectorFactory
      connectorFactory)
  {
    super(application, connectorFactory);
  }

  /**
   * Initializes the Cache.
   */
  @Override
  public void initialize()
  {
    getLog().debug("Registering cache groups.", LogLevel.DEBUG);

    // Register entities.

    register(CacheGroup.of(User.class)
        .table("TCUser")
        .maker(new EntityMaker<User>() {
          @Override
          public User make()
          {
            return TCApplication.getInstance().getSecurity().constructUser();
          }
        }));

    register(CacheGroup.of(Group.class)
        .table("TCGroup"));

    // Register relationships.

//    this.mapUserToGroup = register(CachedRelation.of(User.class, Group.class)
//        .table("TCMapUserToGroup")
//        .leftColumn("UserID")
//        .rightColumn("GroupID"));

    // Add handlers for clustering.
    TCApplication application = (TCApplication)super.getApplication();
    if (application.getClusterClient().isEnabled())
    {
      CacheHandler cacheHandler = new CacheHandler(application);
      application.getClusterClient().addHandler(cacheHandler);
      this.addListener(cacheHandler);
  
      CachedRelationHandler cachedRelationHandler = new CachedRelationHandler(application);
      application.getClusterClient().addHandler(cachedRelationHandler);
      for (CachedRelation<?, ?> relation : this.getRelations())
      {
        relation.addListener(cachedRelationHandler);
      }
    }
  }

}   // End TCCache.

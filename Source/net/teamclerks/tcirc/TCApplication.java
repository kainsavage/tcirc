/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import java.util.ArrayList;
import java.util.List;

import net.teamclerks.tcirc.irc.IrcClient;

import com.techempower.Version;
import com.techempower.cache.EntityStore;
import com.techempower.data.DatabaseConnectionListener;
import com.techempower.gemini.BasicInfrastructure;
import com.techempower.gemini.Configurator;
import com.techempower.gemini.Dispatcher;
import com.techempower.gemini.GeminiApplication;
import com.techempower.gemini.Request;
import com.techempower.gemini.UrlRewriter;
import com.techempower.gemini.cluster.client.ClusterClient;
import com.techempower.gemini.cluster.client.handler.LogNoteHandler;
import com.techempower.gemini.data.BasicConnectorListener;
import com.techempower.gemini.email.outbound.EmailTemplater;
import com.techempower.gemini.pyxis.PyxisApplication;

/**
 * TCIRC Application.  As a subclass of GeminiApplication, this
 * class acts as a central "hub" references to application components
 * such as the Dispatcher and Cache.
 *
 * @see com.techempower.gemini.GeminiApplication
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCApplication
     extends GeminiApplication
  implements PyxisApplication
{
  //
  // Static variables.
  //

  private static TCApplication instance = new TCApplication();

  //
  // Member variables.
  //

  private TCSecurity security;
  
  private final List<IrcClient> ircClients;

  //
  // Member methods.
  //

  /**
   * Constructor.  This method can be extended to construct references
   * to custom components for the application.
   */
  public TCApplication()
  {
    super();
    
    this.ircClients = constructIrcClient();

    // Add the TCInfrastructure as an Asynchronous resource
    // that should be stopped and started along with the application.
    addAsynchronous(getInfrastructure());
  }

  /**
   * Constructs an application-specific Context, for an inbound request.
   * This is overloaded to return a custom TCContext.
   */
  @Override
  public TCContext getContext(Request request)
  {
    return new TCContext(
        request,
        this
    );
  }

  /**
   * Returns the Security for the application.
   */
  @Override
  public TCSecurity getSecurity()
  {
    if (this.security == null)
    {
      this.security = new TCSecurity(this);
    }

    return this.security;
  }

  /**
   * Returns an application-specific reference to the Infrastructure.
   */
  @Override
  public TCInfrastructure getInfrastructure()
  {
    return (TCInfrastructure)super.getInfrastructure();
  }

  /**
   * Returns an application-specific reference to the Configurator.
   */
  @Override
  public TCConfigurator getConfigurator()
  {
    return (TCConfigurator)super.getConfigurator();
  }

  /**
   * Returns an application-specific reference to the Dispatcher.
   */
  @Override
  public TCDispatcher getDispatcher()
  {
    return (TCDispatcher)super.getDispatcher();
  }
  
  /**
   * Returns an application-specific reference to the IrcClient.
   */
  public List<IrcClient> getIrcClients()
  {
  	return this.ircClients;
  }

  //
  // Protected component constructors.
  //

  /**
   * Constructs a Version reference.  This is overloaded to return a
   * custom TCVersion object.
   */
  @Override
  protected Version constructVersion()
  {
    return new TCVersion();
  }

  /**
   * Constructs an CacheController reference.  Overload to return a custom
   * object.
   *   <p>
   * Note: it is acceptable to return null if no object caching is used.
   * The default implementation does exactly that.
   */
  @Override
  protected EntityStore constructEntityStore()
  {
    return new TCCache(this, getConnectorFactory());
  }

  /**
   * Constructs the application's Cluster Client.
   */
  @Override
  protected ClusterClient constructClusterClient()
  {
    ClusterClient client = super.constructClusterClient();
    client.addHandler(new LogNoteHandler(this));
    return client;
  }

  /**
   * Constructs a Infrastructure reference.  This is overloaded to return a
   * custom TCInfrastructure object.
   */
  @Override
  protected BasicInfrastructure constructInfrastructure()
  {
    return new TCInfrastructure(this);
  }

  /**
   * Constructs a Configurator reference.  This is overloaded to return a
   * custom TCConfigurator object.
   */
  @Override
  protected Configurator constructConfigurator()
  {
    return new TCConfigurator(this);
  }

  /**
   * Constructs a Dispatcher reference.  This is overloaded to return a
   * custom TCDispatcher object.
   */
  @Override
  protected Dispatcher constructDispatcher()
  {
    return new TCDispatcher(this);
  }

  /**
   * Construct a DatabaseConnectionListener.  If this returns non-null,
   * this listener object will be provided to the ConnectorFactory instance
   * upon its creation.
   */
  @Override
  protected DatabaseConnectionListener constructDatabaseConnectionListener()
  {
    return new BasicConnectorListener(this);
  }

  /**
   * Constructs an EmailTemplater reference.  This is overloaded to return
   * a custom TCEmailTemplater object.
   */
  @Override
  protected EmailTemplater constructEmailTemplater()
  {
    return new TCEmailTemplater(this);
  }
  
  /**
   * Constructs a UrlRewriter reference. This is overloaded to return a 
   * custom TCUrlRewriter object.
   */
  @Override
  public UrlRewriter constructUrlRewriter()
  {
    return new TCUrlRewriter(this);
  }
  
  /**
   * Construct an IrcClient reference.
   */
  private List<IrcClient> constructIrcClient()
  {
  	return new ArrayList<>();
  }

  //
  // Static methods.
  //

  public static TCApplication getInstance()
  {
    return instance;
  }

}   // End TCApplication.


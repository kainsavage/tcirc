/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc.home.handler;

import net.teamclerks.tcirc.TCApplication;
import net.teamclerks.tcirc.TCContext;
import net.teamclerks.tcirc.TCHandler;
import net.teamclerks.tcirc.home.forms.HomeForm;

import com.techempower.gemini.annotation.CMD;
import com.techempower.gemini.annotation.Default;
import com.techempower.gemini.annotation.response.JSP;
import com.techempower.log.ComponentLog;

/**
 * HomeHandler accepts requests for the home page.
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class HomeHandler
     extends TCHandler
{
	private final TCApplication app;
  private final ComponentLog log;

  /**
   * Constructor.
   */
  public HomeHandler(TCApplication application)
  {
    super(application);
    this.app = application;
    this.log = this.app.getLog("hHom");
    
    this.log.debug("HomeHandler created.");
  }

  /**
   * Renders the home page. 
   * 
   * This is also set as the default handler.
   */
  @Default
  @CMD("home")
  @JSP("home.jsp")
  public boolean handleHome(TCContext context)
  {
  	HomeForm form = new HomeForm(this.app);
  	
  	if (form.hasBeenValidlySubmitted(context))
  	{
			return context.redirect("/chat");
  	}
  	
  	context.putDelivery("form", form);
  	
    return true;
  }

}   // End HomeHandler.


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

import com.techempower.gemini.GeminiHelper;
import com.techempower.gemini.annotation.Default;
import com.techempower.gemini.annotation.URL;
import com.techempower.gemini.form.FormValidation;
import com.techempower.js.JavaScriptWriter;
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
  private final JavaScriptWriter validationWriter = JavaScriptWriter.custom()
      .addVisitorFactory(FormValidation.class, HomeForm.VisitorFactory())
      .build();
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
   * This is also set as the default handler.
   */
  @Default
  public boolean handleDefault(TCContext context)
  {
  	return context.redirect("/html/home.html");
  }
  
  @URL("api/connect")
  public boolean handleConnect(TCContext context)
  {
  	HomeForm form = new HomeForm(this.app);
    form.setValues(context);
    FormValidation validation = form.validate(context);
  	
		if (validation.hasErrors())
		{
			// This has to be fixed
			return GeminiHelper.sendJson(context, validation, validationWriter);
		}
		else
		{
			context.putSessionValue("channel", form.getStringValue("channel"));
			context.putSessionValue("name", form.getStringValue("name"));
			context.putSessionValue("server", form.getStringValue("server"));
			
			return GeminiHelper.sendJson(context, "success","/html/chat.html");
		}
  }

}   // End HomeHandler.


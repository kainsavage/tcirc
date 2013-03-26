package net.teamclerks.tcirc.home.handler;

import net.teamclerks.tcirc.TCApplication;
import net.teamclerks.tcirc.TCContext;
import net.teamclerks.tcirc.TCHandler;

import com.techempower.gemini.annotation.URL;
import com.techempower.gemini.annotation.response.JSP;

public final class AboutHandler extends TCHandler
{
	public AboutHandler(TCApplication application)
  {
	  super(application);
  }

	@URL("about")
	@JSP("about.jsp")
	public boolean handleAbout(TCContext context)
	{
	  return true;
	}
}
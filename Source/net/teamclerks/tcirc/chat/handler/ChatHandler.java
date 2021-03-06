package net.teamclerks.tcirc.chat.handler;

import javax.servlet.ServletException;

import net.teamclerks.tcirc.TCApplication;
import net.teamclerks.tcirc.TCContext;
import net.teamclerks.tcirc.TCHandler;
import net.teamclerks.tcirc.chat.ChatProcessor;

import com.techempower.gemini.annotation.CMD;
import com.techempower.gemini.annotation.response.JSP;
import com.techempower.gemini.websocket.ResinAdapter;
import com.techempower.gemini.websocket.WebsocketAdapter;
import com.techempower.helper.StringHelper;
import com.techempower.log.ComponentLog;

public class ChatHandler extends TCHandler
{
	private final TCApplication    app;
	private final ComponentLog     log;
  private final WebsocketAdapter adapter;

	public ChatHandler(TCApplication application)
	{
		super(application);
		
		this.app = application;
		this.log = this.app.getLog("ChHd");
		this.adapter = new ResinAdapter();
	}

	@CMD("chat")
	@JSP("chat/chat.jsp")
	public boolean handleChat(TCContext context)
	{
		if (StringHelper.isEmpty((String)context.getSessionValue("channel"),
				(String)context.getSessionValue("server"),
				(String)context.getSessionValue("name")))
		{
			return context.redirect("/home");
		}
		return true;
	}
	
	@CMD("chatting")
	public boolean handleChatting(TCContext context)
	{
		try
		{
			this.adapter.promoteToWebsocket(new ChatProcessor(this.app, "chatting", context), 
					context.getRequest().getRawRequest());
		}
		catch (ServletException se)
		{
			this.log.debug("ServletException thrown while promoting to Websocket.", se);
		}
		return true;
	}
}

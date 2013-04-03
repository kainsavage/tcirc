package net.teamclerks.tcirc.chat.handler;

import javax.servlet.ServletException;

import net.teamclerks.tcirc.TCApplication;
import net.teamclerks.tcirc.TCContext;
import net.teamclerks.tcirc.TCHandler;
import net.teamclerks.tcirc.chat.ChatProcessor;

import com.google.common.collect.ImmutableMap;
import com.techempower.gemini.GeminiHelper;
import com.techempower.gemini.annotation.URL;
import com.techempower.gemini.websocket.ResinAdapter;
import com.techempower.gemini.websocket.WebsocketAdapter;
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
	
	@URL("api/chat/data")
	public boolean handleChatData(TCContext context)
	{
		return GeminiHelper.sendJson(context, ImmutableMap.of(
				"channel",    context.getSessionValue("channel"),
				"server",     context.getSessionValue("server"),
				"name",       context.getSessionValue("name"),
				"headerName", context.getSessionValue("server")
				));
	}
	
	@URL("api/chatting")
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

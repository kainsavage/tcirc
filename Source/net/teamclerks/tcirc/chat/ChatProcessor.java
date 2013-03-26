package net.teamclerks.tcirc.chat;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import net.teamclerks.tcirc.TCApplication;
import net.teamclerks.tcirc.TCContext;
import net.teamclerks.tcirc.irc.IrcClient;

import org.jibble.pircbot.IrcException;
import org.jibble.pircbot.NickAlreadyInUseException;

import com.techempower.gemini.websocket.BasicWebsocketProcessor;
import com.techempower.helper.StringHelper;

public class ChatProcessor
  extends BasicWebsocketProcessor
{
  private final String webSocketChannel;
  private final IrcClient client;
  
  // IRC settings
  private String name;
  private final String server;
  private final String channel;
  
  public ChatProcessor(TCApplication app, String webSocketChannel, TCContext context)
  {
    super(app);

    this.webSocketChannel = webSocketChannel;
    
    this.name = context.getSessionValue("name");
    this.server = context.getSessionValue("server");
    this.channel = context.getSessionValue("channel");
    
    this.client = new IrcClient(app, this);
  }
  
  public String getName()
  {
  	return this.name;
  }
  
  @Override
  public void startup()
  {
    super.startup();
		
		try
		{
			this.client.connect(this.server);
		}
		catch (NickAlreadyInUseException naiue)
		{
			// TODO
		}
		catch (IrcException ie)
		{
			// TODO
		}
		catch (IOException ioe)
		{
			// TODO
		}
		
		this.client.joinChannel(this.channel);
  }
  
  public final void reconnect()
  {
		try
		{
			this.client.reconnect();
		}
		catch (NickAlreadyInUseException naiue)
		{
			// TODO
		}
		catch (IrcException ie)
		{
			// TODO
		}
		catch (IOException ioe)
		{
			// TODO
		}
  }
  
  @Override
  public void teardown()
  {
    super.teardown();
    
    if (this.client != null)
    {
	    this.client.disconnect();
	    this.client.dispose();
    }
  }
  
  @Override
  public void readString(String string)
  {
  	// Ignore keep-alive signals from the client.
	  if (!"keep-alive".equals(string))
	  {
		  String inString = StringHelper.truncateEllipsis(
		       StringHelper.stripISOControlCharacters(string, ""), 4000);

		  
		  Map<String,String> data = new HashMap<>();
		  
		  if(StringHelper.startsWithIgnoreCase(inString, "/me "))
		  {
		  	String action = inString.substring(4);

		  	this.client.sendAction(this.channel, action);
		  	
			  data.put("time", IrcClient.TIMESTAMP.format(new Date()));
			  data.put("message", "<font class='action'>" + this.name + " " + action + "</font>");
			  
			  this.sendJson("myMessage", data);
		  }
		  else if(StringHelper.startsWithIgnoreCase(inString, "/join "))
		  {
		  }
		  else if(StringHelper.startsWithIgnoreCase(inString, "/kick "))
		  {
		  }
		  else if(StringHelper.startsWithIgnoreCase(inString, "/nick "))
		  {
		  	String newNick = inString.substring(6);
		  	
		  	this.client.changeNick(newNick);
		  }
		  else if(StringHelper.startsWithIgnoreCase(inString, "/msg "))
		  {
		  	String toNick = null;
		  	StringBuilder message = new StringBuilder();
		  	for(String text : inString.substring(5).split("\\s"))
		  	{
		  		if(StringHelper.isEmpty(toNick))
		  		{
		  			toNick = text;
		  		}
		  		else
		  		{
		  			message.append(text + " ");
		  		}
		  	}
		  	this.client.sendMessage(toNick, message.toString());
		  }
		  else
		  {
		  	this.client.sendMessage(this.channel, inString);
			  data.put("time", IrcClient.TIMESTAMP.format(new Date()));
			  data.put("message", ChatProcessor.toWebFriendlyString(inString));
			  data.put("sender", this.name);
			  data.put("channel", this.channel);
			  data.put("hostname", this.server);
		  	data.put("who", "me");
			  
			  this.sendJson("myMessage", data);
		  }
	  }
  }
  
  public String getWebSocketChannel()
  {
  	return this.webSocketChannel;
  }
  
  /**
   * Converts the given string into a web-friendly version of itself. Removes
   * any unsafe characters for rendering to a web-client (like &lt; and &gt;)
   * and converts any URLs into anchor tags to render.
   * @param message
   */
	public static String toWebFriendlyString(String message)
	{
		// We need to decode everything so that we can replace all the ampersands later.
		String localMessage = message
				.replaceAll("&nbsp;", " ")
				.replaceAll("&amp;", "&")
				.replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">");
		StringBuilder parsedMessage = new StringBuilder();
		
		for(String part : localMessage.split("\\s"))
		{
			try
			{
				if (part.startsWith("www."))
				{
					part = "http://" + part;
				}
				URL url = new URL(part);
				// If we haven't thrown an error, then it WAS a parsable URL.
				parsedMessage.append("<a href='" + url.toExternalForm() + "' target='_blank'>" + filter(part) + "</a>");
			}
			catch(MalformedURLException murle)
			{
				// Okay, it wasn't a url, filter and append it.
				parsedMessage.append(filter(part));
			}
			parsedMessage.append(" ");
		}
		
		return parsedMessage.toString();
	}
	
	/**
	 * Filters out any unwanted (possibly unsafe) characters for rendering 
	 * to the web client from the given string.
	 * @param text
	 */
	private static final String filter(String text)
	{
		return text
				.replaceAll("&", "&amp;")
				.replaceAll("<","&lt;")
				.replaceAll(">", "&gt;");
	}
}

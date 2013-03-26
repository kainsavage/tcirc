package net.teamclerks.tcirc.irc;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.teamclerks.tcirc.TCApplication;
import net.teamclerks.tcirc.chat.ChatProcessor;

import org.jibble.pircbot.DccChat;
import org.jibble.pircbot.DccFileTransfer;
import org.jibble.pircbot.PircBot;
import org.jibble.pircbot.User;

import com.techempower.helper.StringHelper;
import com.techempower.log.ComponentLog;
import com.techempower.text.SynchronizedSimpleDateFormat;

public class IrcClient 
  extends PircBot
{
	public static final SynchronizedSimpleDateFormat TIMESTAMP = new SynchronizedSimpleDateFormat("HH:mm");
	
	private final TCApplication app;
	private final ComponentLog  log;
	private final ChatProcessor chatProcessor;
	
	private boolean intentionallyDisconnected = false;

	public IrcClient(TCApplication application, ChatProcessor processor)
	{
		this.app = application;
		this.log = this.app.getLog("IRCC");
		
		this.setName(processor.getName());
		
		this.chatProcessor = processor;
		
		this.log.debug("IrcClient initialized.");
	}
	
	public final void disconnectIntentionally()
	{
		this.intentionallyDisconnected = true;
		this.disconnect();
	}
	
	@Override
  protected void handleLine(String line)
  {
	  super.handleLine(line);
  }

	@Override
  protected void onConnect()
  {
	  super.onConnect();

	  Map<String,String> data = new HashMap<>();
	  data.put("time", TIMESTAMP.format(new Date()));
	  data.put("message", "<font class='connect'>*** You have connected to the server.</font>");
	  
	  this.log.debug("onConnect call.");
	  
	  this.chatProcessor.sendJson("connected", data);
  }

	@Override
  protected void onDisconnect()
  {
	  super.onDisconnect();

	  Map<String,String> data = new HashMap<>();
	  data.put("time", TIMESTAMP.format(new Date()));
	  data.put("message", "<font class='disconnect'>*** You have disconnected from the server.</font>");
	  
	  this.log.debug("onDisconnect call.");
	  
	  if(!this.intentionallyDisconnected)
	  {
	  	// Then let's try and reconnect.
	  	this.chatProcessor.reconnect();
	  }
	  
	  this.chatProcessor.sendJson("disconnected", data);
  }

	@Override
  protected void onServerResponse(int code, String response)
  {
	  super.onServerResponse(code, response);
  }

	@Override
  protected void onUserList(String aChannel, User[] users)
  {
	  super.onUserList(aChannel, users);
	  
	  List<String> nicks = new ArrayList<>();
	  for (User user : users)
	  {
	  	nicks.add(user.getNick());
	  }
	  
	  Map<String,List<String>> data = new HashMap<>();
	  data.put("nicks", nicks);
	  
	  this.log.debug("onUserList call.");
	  
	  this.chatProcessor.sendJson("userlist", data);
  }

	@Override
  protected void onMessage(String aChannel, String sender, String login,
      String hostname, String message)
  {
	  super.onMessage(aChannel, sender, login, hostname, message);

	  Map<String,String> data = new HashMap<>();
	  data.put("time", TIMESTAMP.format(new Date()));
	  data.put("channel", aChannel);
	  data.put("sender", sender);
	  data.put("login", login);
	  data.put("hostname", hostname);
	  data.put("message", ChatProcessor.toWebFriendlyString(message));
	  
	  if (StringHelper.equalsIgnoreCase(sender, this.chatProcessor.getName()))
	  {
	  	data.put("who", "me");
	  }
	  else
	  {
	  	data.put("notify", "true");
	  }
	  
	  this.log.debug("onMessage call.");
	  
	  this.chatProcessor.sendJson("message", data);
  }

	@Override
  protected void onPrivateMessage(String sender, String login, String hostname,
      String message)
  {
	  super.onPrivateMessage(sender, login, hostname, message);
  }

	@Override
  protected void onAction(String sender, String login, String hostname,
      String target, String action)
  {
	  super.onAction(sender, login, hostname, target, action);

	  Map<String,String> data = new HashMap<>();
	  data.put("time", TIMESTAMP.format(new Date()));
	  data.put("message", "<font class='action'>" + sender + " " + action + "</font>");
	  
	  this.log.debug("onAction call.");
	  
	  this.chatProcessor.sendJson("action", data);
  }

	@Override
  protected void onNotice(String sourceNick, String sourceLogin,
      String sourceHostname, String target, String notice)
  {
	  super.onNotice(sourceNick, sourceLogin, sourceHostname, target, notice);
  }

	@Override
  protected void onJoin(String aChannel, String sender, String login,
      String hostname)
  {
	  super.onJoin(aChannel, sender, login, hostname);

	  Map<String,String> data = new HashMap<>();
	  data.put("time", TIMESTAMP.format(new Date()));
	  data.put("message", "<font class='connect'>*** " + sender + " has joined " + aChannel + "</font>");
	  data.put("channel", aChannel);
	  data.put("joiner", sender);
	  
	  this.log.debug("onJoin call.");
	  
	  this.chatProcessor.sendJson("joined", data);
  }

	@Override
  protected void onPart(String aChannel, String sender, String login,
      String hostname)
  {
	  super.onPart(aChannel, sender, login, hostname);

	  Map<String,String> data = new HashMap<>();
	  data.put("time", TIMESTAMP.format(new Date()));
	  data.put("message", "<font class='disconnect'>*** " + sender + " has left " + aChannel + "</font>");
	  data.put("channel", aChannel);
	  data.put("parted", sender);
	  
	  this.log.debug("onPart call.");
	  
	  this.chatProcessor.sendJson("parted", data);
  }

	@Override
  protected void onNickChange(String oldNick, String login, String hostname,
      String newNick)
  {
	  super.onNickChange(oldNick, login, hostname, newNick);
	  
	  Map<String,String> data = new HashMap<>();
	  data.put("time", TIMESTAMP.format(new Date()));
	  data.put("oldNick", oldNick);
	  data.put("newNick", newNick);
	  data.put("message", "<font class='servertext'>*** </font><font class='oldNick'>" + oldNick + "</font> <font class='servertext'>is now known as </font><font class='newNick'>" + newNick + "</font>");
	  
	  this.log.debug("onNickChange call.");
	  
	  this.chatProcessor.sendJson("nickchange", data);
  }

	@Override
  protected void onKick(String aChannel, String kickerNick, String kickerLogin,
      String kickerHostname, String recipientNick, String reason)
  {
	  super.onKick(aChannel, kickerNick, kickerLogin, kickerHostname, recipientNick,
	      reason);
  }

	@Override
  protected void onQuit(String sourceNick, String sourceLogin,
      String sourceHostname, String reason)
  {
	  super.onQuit(sourceNick, sourceLogin, sourceHostname, reason);
	  
	  Map<String,String> data = new HashMap<>();
	  data.put("time", TIMESTAMP.format(new Date()));
	  data.put("message", "<font class='disconnect'>*** " + sourceNick + " has quit (" + StringHelper.emptyDefault(reason, "No reason") + ")</font>");
	  data.put("sourceNick", sourceNick);
	  
	  this.log.debug("onPart call.");
	  
	  this.chatProcessor.sendJson("quit", data);
  }

	@Override
  protected void onTopic(String aChannel, String topic, String setBy, long date,
      boolean changed)
  {
	  super.onTopic(aChannel, topic, setBy, date, changed);
  }

	@Override
  protected void onChannelInfo(String aChannel, int userCount, String topic)
  {
	  super.onChannelInfo(aChannel, userCount, topic);
  }

	@Override
  protected void onMode(String aChannel, String sourceNick, String sourceLogin,
      String sourceHostname, String mode)
  {
	  super.onMode(aChannel, sourceNick, sourceLogin, sourceHostname, mode);
  }

	@Override
  protected void onUserMode(String targetNick, String sourceNick,
      String sourceLogin, String sourceHostname, String mode)
  {
	  super.onUserMode(targetNick, sourceNick, sourceLogin, sourceHostname, mode);
  }

	@Override
  protected void onOp(String aChannel, String sourceNick, String sourceLogin,
      String sourceHostname, String recipient)
  {
	  super.onOp(aChannel, sourceNick, sourceLogin, sourceHostname, recipient);
  }

	@Override
  protected void onDeop(String aChannel, String sourceNick, String sourceLogin,
      String sourceHostname, String recipient)
  {
	  super.onDeop(aChannel, sourceNick, sourceLogin, sourceHostname, recipient);
  }

	@Override
  protected void onVoice(String aChannel, String sourceNick, String sourceLogin,
      String sourceHostname, String recipient)
  {
	  super.onVoice(aChannel, sourceNick, sourceLogin, sourceHostname, recipient);
  }

	@Override
  protected void onDeVoice(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname, String recipient)
  {
	  super.onDeVoice(aChannel, sourceNick, sourceLogin, sourceHostname, recipient);
  }

	@Override
  protected void onSetChannelKey(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname, String key)
  {
	  super.onSetChannelKey(aChannel, sourceNick, sourceLogin, sourceHostname, key);
  }

	@Override
  protected void onRemoveChannelKey(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname, String key)
  {
	  super.onRemoveChannelKey(aChannel, sourceNick, sourceLogin, sourceHostname, key);
  }

	@Override
  protected void onSetChannelLimit(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname, int limit)
  {
	  super
	      .onSetChannelLimit(aChannel, sourceNick, sourceLogin, sourceHostname, limit);
  }

	@Override
  protected void onRemoveChannelLimit(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onRemoveChannelLimit(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onSetChannelBan(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname, String hostmask)
  {
	  super.onSetChannelBan(aChannel, sourceNick, sourceLogin, sourceHostname,
	      hostmask);
  }

	@Override
  protected void onRemoveChannelBan(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname, String hostmask)
  {
	  super.onRemoveChannelBan(aChannel, sourceNick, sourceLogin, sourceHostname,
	      hostmask);
  }

	@Override
  protected void onSetTopicProtection(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onSetTopicProtection(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onRemoveTopicProtection(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onRemoveTopicProtection(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onSetNoExternalMessages(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onSetNoExternalMessages(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onRemoveNoExternalMessages(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onRemoveNoExternalMessages(aChannel, sourceNick, sourceLogin,
	      sourceHostname);
  }

	@Override
  protected void onSetInviteOnly(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onSetInviteOnly(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onRemoveInviteOnly(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onRemoveInviteOnly(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onSetModerated(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onSetModerated(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onRemoveModerated(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onRemoveModerated(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onSetPrivate(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onSetPrivate(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onRemovePrivate(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onRemovePrivate(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onSetSecret(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onSetSecret(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onRemoveSecret(String aChannel, String sourceNick,
      String sourceLogin, String sourceHostname)
  {
	  super.onRemoveSecret(aChannel, sourceNick, sourceLogin, sourceHostname);
  }

	@Override
  protected void onInvite(String targetNick, String sourceNick,
      String sourceLogin, String sourceHostname, String aChannel)
  {
	  super.onInvite(targetNick, sourceNick, sourceLogin, sourceHostname, aChannel);
  }

	@Override
  protected void onIncomingFileTransfer(DccFileTransfer transfer)
  {
	  super.onIncomingFileTransfer(transfer);
  }

	@Override
  protected void onFileTransferFinished(DccFileTransfer transfer, Exception e)
  {
	  super.onFileTransferFinished(transfer, e);
  }

	@Override
  protected void onIncomingChatRequest(DccChat chat)
  {
	  super.onIncomingChatRequest(chat);
  }

	@Override
  protected void onVersion(String sourceNick, String sourceLogin,
      String sourceHostname, String target)
  {
	  super.onVersion(sourceNick, sourceLogin, sourceHostname, target);
  }

	@Override
  protected void onPing(String sourceNick, String sourceLogin,
      String sourceHostname, String target, String pingValue)
  {
	  super.onPing(sourceNick, sourceLogin, sourceHostname, target, pingValue);
  }

	@Override
  protected void onServerPing(String response)
  {
	  super.onServerPing(response);
  }

	@Override
  protected void onTime(String sourceNick, String sourceLogin,
      String sourceHostname, String target)
  {
	  super.onTime(sourceNick, sourceLogin, sourceHostname, target);
  }

	@Override
  protected void onFinger(String sourceNick, String sourceLogin,
      String sourceHostname, String target)
  {
	  super.onFinger(sourceNick, sourceLogin, sourceHostname, target);
  }

	@Override
  protected void onUnknown(String line)
  {
	  super.onUnknown(line);
  }
}

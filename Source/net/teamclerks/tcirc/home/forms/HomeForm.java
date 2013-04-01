package net.teamclerks.tcirc.home.forms;

import java.util.Map;

import com.google.common.collect.Maps;
import com.techempower.gemini.Context;
import com.techempower.gemini.GeminiApplication;
import com.techempower.gemini.form.Form;
import com.techempower.gemini.form.FormElement;
import com.techempower.gemini.form.FormSingleValidation;
import com.techempower.gemini.form.FormTextField;
import com.techempower.gemini.form.FormValidation;
import com.techempower.gemini.form.validator.AlphanumericValidator;
import com.techempower.js.Visitor;
import com.techempower.js.VisitorFactory;
import com.techempower.js.Visitors;

public final class HomeForm extends Form
{
	public static final VisitorFactory<FormValidation> VisitorFactory()
	{
		return new VisitorFactory<FormValidation>()
		{
		  @Override
		  public Visitor visitor(FormValidation result)
		  {
		  	Map<String,String> errorsAndValues = Maps.newHashMap();
		  	
		  	for(FormSingleValidation val : result.getValidations())
		  	{
		  		if (val.isError())
		  		{
		  			errorsAndValues.put(val.getElement().getName() + "Error", val.getInstruction());
		  		}
		  	}
		  	
		  	for(FormElement element : result.getForm().getElementsAsList())
		  	{
		  		errorsAndValues.put(element.getName(), element.getEscapedValue());
		  	}
		  	
		    return Visitors.forMaps().visitor(errorsAndValues);
		  }
		};
	}
	
	public HomeForm(GeminiApplication application)
	{
		super(application);
		
		FormTextField name = new FormTextField("name");
		name.setDisplayName("Nickname");
		name.setRequired(true);
		name.setMaxLength(255);
		name.setHelpText("The nickname you wish to use once connected.");
		name.addValidator(new AlphanumericValidator());
		this.addElement(name);
		
		FormTextField server = new FormTextField("server");
		server.setDisplayName("IRC Server");
		server.setRequired(true);
		server.setMaxLength(255);
		server.setHelpText("The IRC server to which you wish to connect.");
		this.addElement(server);
		
		FormTextField channel = new FormTextField("channel");
		channel.setDisplayName("Channel");
		channel.setRequired(true);
		channel.setMaxLength(255);
		channel.setHelpText("The channel to which you wish to join once connected.");
		this.addElement(channel);
	}
	
	/**
	 * Sets the values of the form in the session to be used later.
	 * @param context
	 */
	@Override
  protected <C extends Context> void onValidlySubmitted(C context)
	{
		String name = this.getStringValue("name");
		String server = this.getStringValue("server");
		String channel = this.getStringValue("channel");
		
		context.putSessionValue("name", name);
		context.putSessionValue("server", server);
		context.putSessionValue("channel", channel);
	}
}
/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import com.techempower.gemini.*;
import com.techempower.gemini.email.outbound.*;
import com.techempower.util.*;

/**
 * An EmailTemplater for TCIRC.
 *
 * @see com.techempower.gemini.email.outbound.EmailTemplater
 *
 * Development history:
 *   2013-01-24 - ks - Created
 *
 * @author kain
 */
public class TCEmailTemplater
     extends SimpleEmailTemplater
{

  //
  // Member variables.
  //

  private String fromEmailAddress = "kain@teamclerks.net";

  //
  // Member methods.
  //

  /**
   * Constructor.
   */
  public TCEmailTemplater(GeminiApplication application)
  {
    super(application);

    addTemplateToLoad("E-NewPassword");
  }

  /**
   * Configures this component.  Overload this method to load emails.
   */
  @Override
  public void configure(EnhancedProperties props)
  {
    super.configure(props);

    this.fromEmailAddress = props.getProperty("FromEmailAddress", this.fromEmailAddress);
    getLog().debug("E-mail author: " + this.fromEmailAddress);

    // Conventionally, an application will load its Email Templates using
    // the approach shown below.  However, it is also possible and may be 
    // preferable to use EmailTemplater.addEmailToLoad(String), which 
    // results in templates being loaded by the super.configure(props)
    // call you see above.
    /*
    int loaded = 0;
    loaded += addEmail(props, "E-SomeEmail");
    loaded += addEmail(props, "E-SomeOtherEmail");

    log.debug(loaded + " e-mails loaded.");
    */
  }

  /**
   * Gets the author e-mail address.
   */
  public String getEmailAuthor()
  {
    return this.fromEmailAddress;
  }

}   // End TCEmailTemplater.

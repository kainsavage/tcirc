/**
 * Copyright (c) 2013
 * TeamClerks
 * All Rights Reserved.
 *
 * TCIRC
 */

package net.teamclerks.tcirc;

import com.techempower.gemini.*;
import com.techempower.gemini.jsp.*;
import com.techempower.gemini.messaging.*;

/**
 * Provides all JSP pages within the web site with a common foundation.
 *   <p>
 * This foundation provides the following checks: <ul>
 *
 *  <li> Disallow direct JSP invocation, if selected by configuration.
 *  <li> Use Configurator to configure system, if necessary.
 *
 * </ul>
 *   <p>
 * All JSPs in the project should contain as the first line an extends
 * directive.  Within all TCIRC JSP files, the following line
 * should exist at the top of the file:
 *   <p>
 * <pre><br>
 *   <%@ page extends="net.teamclerks.tcirc.TCJSP" %>
 * </pre>
 *   <p>
 * JSPs should use the provided reference to the Context in order to
 * retrieve deliveries.  The Context object is delivered to the JSP as
 * a request attribute.  Get a reference to it As below:
 *    <p>
 * <pre><br>
 *   <%
 *     Context context = (Context)request.getAttribute("Context");
 *   %>
 * </pre>
 *
 * Development history:
 *   2013-01-24 - ks - Class created
 *
 * @see com.techempower.gemini.jsp.InfrastructureJsp
 * @see com.techempower.gemini.jsp.BasicJsp
 *
 * @author kain
 */
public abstract class TCJsp
              extends BasicJsp
{
  /**
   * This is not final so it can be overridden by a more precise
   * method.
   */
  @Override
  public String getServletInfo()
  {
    return "TCIRC JSP";
  }

  /**
   * Gets a GeminiApplication object for this application.
   */
  @Override
  public TCApplication getApplicationReference()
  {
    return TCApplication.getInstance();
  }

  /**
   * Renders (and removes) all messages in the queue.  
   */
  public String renderMessages(Context context)
  {
    StringBuilder sb = new StringBuilder();
    for (Message message : context.getMessages())
    {
      sb.append(message.renderAsP(false));
    }
    return sb.toString();
  }

}   // End TCJSP.


<%
  // This is a simple example rendering for the Administration Subnav.
  //
  // This can be included in your implementation of include-custom-page-header.jsp
  //
  // You would typically render the subnav within a region of your page structure
  // that can be dedicated to administrative functionality.  Your site's main
  // navigation should be considered separate and can be rendered separately
  // outside of that region by include-custom-page-header.jsp as well.

  Iterator navIter = nav.iterator();
  SimpleLink simpleLink;
  if (navIter.hasNext())
  {
    %><nav id="admnav"><%
    while (navIter.hasNext())
    {
      simpleLink = (SimpleLink)navIter.next();
      %><a href="<%= simpleLink.url %>"><%= simpleLink.linkName %></a><%
    }
    %></nav><%
  }
%>
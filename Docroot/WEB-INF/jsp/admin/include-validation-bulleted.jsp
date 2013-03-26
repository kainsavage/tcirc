<%
if (validation != null)
{
  %><ul><%
  Iterator validationIterator = validation.getInstructionIterator();
  while (validationIterator.hasNext())
  {
    %><li><%= validationIterator.next() %></li><%
  }
  %></ul><%
}
%>
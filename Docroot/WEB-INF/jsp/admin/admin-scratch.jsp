<%@ include file="include-extends.jsp"
%><%@ include file="include-standard-variables.jsp" %><%

// ----------------------------------------------------------------------
// Gemini Basic Administration Site
// ----------------------------------------------------------------------
//
// File: basicadmin/admin-scratch.jsp
// Edit scratch JSPs
//
// ----------------------------------------------------------------------

String[] files = (String[])context.getDelivery("Files");
String template = context.getStringDelivery("Template");
JavaScriptWriter jsW = JavaScriptWriter.standard();

String runUrl = context.getCmdURL("admin-scratch-run&jsp=");
String loadUrl = context.getCmdURL("admin-scratch-load&jsp=");
String saveUrl = context.getCmdURL("admin-scratch-save");
String delUrl = context.getCmdURL("admin-scratch-delete&jsp=");

vars.title = getTitle("Scratch Files");

nav.add(new SimpleLink("Scratch Files", context.getCmdURL("admin-scratch")));

%><%@ include file="include-custom-page-header.jsp" %>

<%@ include file="include-message.jsp" %>

<h2>Scratch File Editor</h2>

<table border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td valign="top" width="90%">

Filename: <input name="filename" id="filename" length="100" type="text" style="width: 200px" /><br/>
<textarea name="body" id="body" wrap="auto" style="width: 100%; height: 300px;"></textarea><br/>
<p><a class="admbutton" href="javascript:save();">Save</a> &nbsp; <a class="admbutton" href="javascript:newScratch();">New</a></p>

<h2>Output</h2>
<div id="runname" style="background-color: #9090A0; padding-top: 5px; padding-left: 5px; color: white; font-weight: bold;">--</div>
<div id="output" style="border: 4px solid #9090A0; padding: 5px;">-- no output available --</div>

</td>

<td>&nbsp;&nbsp;</td>

<td valign="top">

<table border="0" cellspacing="0" cellpadding="0">
<tr class="admheader"><td>Files</td></tr>
<tbody id="files">
</tbody>
</table>

</td>
</tr>
</table>

<%@ include file="include-custom-page-footer.jsp" %>

<script type="text/javascript">

var files = <%= jsW.write(files) %>;
var template = <%= jsW.write(template) %>;
var runUrl = <%= jsW.write(runUrl) %>;
var loadUrl = <%= jsW.write(loadUrl) %>;
var saveUrl = <%= jsW.write(saveUrl) %>;
var delUrl = <%= jsW.write(delUrl) %>;

newScratch();
renderFilesList(files);

function newScratch()
{
  $("textarea#body").val(template);
  $("input#filename").val("scratch.jsp").focus();
}

function renderFilesList(files)
{
  content = ""
  for (i = 0; i < files.length; i++)
  {
    content += "<tr><td class='admconfvalue'>" + files[i] + "<br/><a href='javascript:load(\"" + files[i] + "\");'>Load</a>&nbsp;<a href='javascript:run(\"" + files[i] + "\",\"html\");'>Run</a>&nbsp;<a href='javascript:run(\"" + files[i] + "\",\"text\");'>Run&nbsp;(text)</a>&nbsp;<a href='javascript:deleteScratch(\"" + files[i] + "\");'>Delete</a></td></tr>";
  }
  $("#files").html(content);
}

function run(name, type)
{
   if (type == 'html')
     $("div#runname").text(name);
   else
     $("div#runname").text(name + " (as plaintext)");
   $("div#output").html("<div style='text-align: center; padding: 30px; color: #9090A0; font-weight: bold'>Compiling and running, please wait...</div>");
   $.ajax({
    url: runUrl + name,
    dataType: type,
    success: function(data)
      {
        if (type == 'html')
          $("div#output").html(data);
        else
          $("div#output").text(data);
      },
    error: function(req, status, error)
      {
        $("div#output").html("Error running requested scratch file.");
      }
    });
}

function load(name)
{
  $("input#filename").val(name);
  $.ajax({
    url: loadUrl + name,
    dataType: 'json',
    success: function(data)
      {
        $("textarea#body").val(data.body).focus();
        $("div#runname").text("--");
        $("div#output").html(name + " loaded.");
      },
    error: function(req, status, error)
      {
        $("textarea#body").val(template);
        $("div#runname").text("--");
        $("div#output").html("Error loading requested scratch file; template loaded.");
      }
    });
}

function save()
{
  var filename = $("input#filename").val();
  var body = $("textarea#body").val();
  $.ajax({
    url: saveUrl,
    data: { 'jsp': filename, 'body': body },
    dataType: 'json',
    success: function(data)
      {
        if (data.files)
        {
          renderFilesList(data.files);
          $("div#runname").text("--");
          $("div#output").html(filename + " saved successfully.");
        }
        else
        {
          $("div#runname").text("--");
          $("div#output").html("Error saving scratch file.");
        }
      },
    error: function(req, status, error)
      {
        $("div#runname").text("--");
        $("div#output").html("Error saving scratch file.");
      }
    });
}

function deleteScratch(name)
{
  $.ajax({
    url: delUrl + name,
    dataType: 'json',
    success: function(data)
      {
        if (data.files)
        {
          renderFilesList(data.files);
          $("div#runname").text("--");
          $("div#output").html(name + " deleted.");
        }
        else
        {
          $("div#runname").text("--");
          $("div#output").html("Error deleting scratch file.");
        }
      },
    error: function(req, status, error)
      {
        $("div#runname").text("--");
        $("div#output").html("Error deleting scratch file.");
      }
    });
}

</script>
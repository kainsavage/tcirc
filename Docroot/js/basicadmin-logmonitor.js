/*
Gemini Basic Administration
JavaScript for real-time log monitoring
*/

/* Global variables. */
var uid = 0;
var logBuffer = new Array();
var dispCurr = 0;
var dispThreshold = 30;
var containReq = "";
var repaintTimeout = 0;
var ajaxInterval = 0;
var capture = 1;
var track = 1;
var ignored = 0;

/* Paint details; wire up the filter; and start fetching log items. */
function startLogMonitor()
{
  createSeverityClasses();
  debug("Attaching listener to log file at " + standardDateString(new Date()) + ".", 50);
  displayChannelInfo();

  // Capture keypresses on the filter box.
  $("input#filter").keyup(function(event)
  {
    var curVal = containReq;
    containReq = this.value.toLowerCase();
    if (curVal != containReq)
    {
      if (repaintTimeout > 0) window.clearTimeout(repaintTimeout);
      repaintTimeout = window.setTimeout(repaintLog, 100);
    }
  });

  // Focus the filter box.
  document.getElementById('filter').focus();

  // Start fetching.
  startAjaxFetching();
}

/* Render a summary of the current channel's filter settings. */
function displayChannelInfo()
{
  var toAdd;
  if (channel)
  {
    toAdd = channel.name
      + " (levels " + channel.min
      + " to " + channel.max
      + (channel.contains ? (" containing \"" + channel.contains + "\"") : "")
      + (channel .regex ? (" matching regex \"" + channel.regex + "\"") : "")
      + ")";
  }
  else
  {
    toAdd = "Unknown log channel";
  }
  $("span#channel").html(toAdd);
}

/*
// Web Socket stuff.
function wsOpen(event)
{
  window.alert("<p>Socket opened.</p>");
}
function wsMessage(event)
{
  data = event.data;
  debug("Received [" + data + "]<br/>");
}
function wsClose(event)
{
  debug("<p>Web socket " + event + " is closed.</p>");
}
debug("<p>Socket url: " + svUrl + "</p>");
var ws = new WebSocket(svUrl);
wsOpen.ws = ws;
ws.onopen = wsOpen;
ws.onmessage = wsMessage;
ws.onclose = wsClose;
*/

/* Toggle the pause/capture mode. */
function toggleCapture()
{
  if (capture)
  {
    capture = 0;
    $("div#banner span#controls a#togglecapture").addClass("selected").blur();
    pauseAjaxFetching();
  }
  else
  {
    repaintLog();
    capture = 1;
    $("div#banner span#controls a#togglecapture").removeClass("selected").blur();
    startAjaxFetching();
  }
}

/* Toggle the scroll tracking mode. */
function toggleTrack()
{
  if (track)
  {
    track = 0;
    $("div#banner span#controls a#toggletrack").removeClass("selected").blur();
  }
  else
  {
    jumpToBottom();
    track = 1;
    $("div#banner span#controls a#toggletrack").addClass("selected").blur();
  }
}

/* Capture a log item and display the item if it meets the client-side filters. */
function debug(text, level)
{
  var logItem = { 'uid': uid++, 'level': level, 'text': text };

  // Remove top item from the buffer if at maximum length.
  if (logBuffer.length >= maxLines)
  {
    logBuffer.shift();
    if (capture)
    {
      var toRemove = uid - maxLines - 1;
      $("tr#line" + toRemove).remove();
    }
  }

  // Add the item to our buffer.
  logBuffer.push(logItem);

  if (meetsCriteria(logItem))
  {
    displaySingle(logItem);
  }

  showStats();
}

/* Turns a log item into HTML. */
function renderSingleAsHtml(logItem)
{
  return "<tr id='line" + logItem.uid + "'><td class='content l" + logItem.level + "'>" + logItem.text + "</td></tr>";
}

/* Add a log item into the view assuming we're capturing. */
function displaySingle(logItem)
{
  if (capture == 1)
  {
    var toAdd = renderSingleAsHtml(logItem);
    dispCurr++;
    $("tbody#logdata").append(toAdd);
    jumpIfFollow();
  }
  else
  {
    ignored++;
  }
}

/* If we're following the log, scroll down. */
function jumpIfFollow()
{
  if (track)
  {
    jumpToBottom();
  }
}

/* Scroll to the bottom of the page. */
function jumpToBottom()
{
  $("body").scrollTop(10000000);
}

/* Adjust the minimum threshold and repaint. */
function setThreshold(newThreshold)
{
  dispThreshold = newThreshold;
  $("div#banner span#levels a").removeClass("selected").blur();
  $("div#banner span#levels a#t" + dispThreshold).addClass("selected");
  repaintLog();
}

/* Clear the view and re-render it entirely given current client-side settings. */
function repaintLog()
{
  dispCurr = 0;
  var toAdd = "";
  for (var i = 0; i < logBuffer.length; i++)
  {
    if (meetsCriteria(logBuffer[i]))
    {
      toAdd += renderSingleAsHtml(logBuffer[i]);
      dispCurr++;
    }
  }

  $("tbody#logdata").html(toAdd);

  showStats();
  jumpIfFollow();
}

/* Determines if a log item meets the current client-side criteria. */
function meetsCriteria(logItem)
{
  if (logItem.level >= dispThreshold)
  {
    if ( (containReq == "")
      || (logItem.text.toLowerCase().indexOf(containReq) >= 0)
      )
    {
      return true;
    }
  }
  return false;
}

/* Display how many lines are visible versus captured. */
function showStats()
{
  var displayed = $("#logdata").children().length;
  $("span#displayed").text(displayed);
  $("span#captured").text(logBuffer.length);
}

/* Create a gradient of colors for log severity. */
var sr = 168, sg = 168, sb = 128, offset = 0;
function createSeverityClasses()
{
  var toAdd = "";
  toAdd += createGradient(-4, -4, 4, 15);  // Start with gray
  toAdd += createGradient(-1, 4, -6, 20);  // Blend to blue
  toAdd += createGradient(-6, -8, -4, 20); // Blend to green
  toAdd += createGradient(-6, -6, -6, 5);  // Blend to black
  toAdd += createGradient(12, 6, 0, 20);   // Blend to orange
  toAdd += createGradient(1, -2, 0, 10);   // Blend to red
  toAdd += createGradient(4, -10, 0, 11);  // Blend to bright red

  $("head").append("<style>" + toAdd + "</style>");
}

function createGradient(dr, dg, db, num)
{
  var res = "";
  for (i = 0; i < num; i++)
  {
    res += ".l" + (offset++) + " { color: rgb(" + sr + "," + sg + "," + sb + "); } ";
    sr += dr; if (sr > 255) sr = 255; if (sr < 0) sr = 0;
    sg += dg; if (sg > 255) sg = 255; if (sg < 0) sg = 0;
    sb += db; if (sb > 255) sb = 255; if (sb < 0) sb = 0;
  }

  return res;
}

function processAjaxFetch(data)
{
  if (data.uid)
  {
    since = data.uid;
  }
  if (data.items)
  {
    for (var i = 0; i < data.items.length; i++)
    {
      debug(data.items[i].text, data.items[i].level);
    }
  }
}

var since = 0;
function fetchViaAjax()
{
  $.ajax({
    url: svUrl + "?cmd=admin-log-monitor&act=ajax&ch=" + channelID + "&since=" + since,
    dataType: 'json',
    type: 'get',
    data: {},
    success: processAjaxFetch
    });
}

function startAjaxFetching()
{
  window.clearInterval(ajaxInterval);
  ajaxInterval = window.setInterval(fetchViaAjax, 500);
}

function pauseAjaxFetching()
{
  window.clearInterval(ajaxInterval);
}

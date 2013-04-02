/**
 * This is the controller code for the chat page.
 */
$(function(){

  'use strict';
  // -------------------------------------------- //
  //               Private variables              //
  // -------------------------------------------- // 
  var focused,
      distributor = null,
      webSocket = null,
      startingTitle = document.title,

      // -------------------------------------------- //
      //                Private methods               //
      // -------------------------------------------- //

      /**
       * Create a data distributor for inbound WebSocket data.
       * @param dataHandlerMap
       * @returns {Function}
       */
      createDataDistributor = function (dataHandlerMap) {
        return function (data) {
          // Fan out to handler methods by key.
          var key,
            val,
            handler;

          // Call the handler associated with each key in the provided data.
          for (key in data) {
            val = data[key];
            if (val) {
              handler = dataHandlerMap[key];
              if (handler) {
                // Provide a default DOM selector to each handler.
                handler(val, "#" + key);
              }
            }
          }
        };
      },
  
      /**
       * Creates a socket and a timeout to keep said socket alive.
       * @param relativeUrl
       * @param dataProtocol
       * @param dataDistributor
       */
      createSocket = function (relativeUrl, dataProtocol, dataDistributor) {
        try {
          var ws = new WebSocket("ws://" + relativeUrl, dataProtocol);
          
          // Receive data as a WebSocket event and decode from JSON before calling the distributor.
          ws.onmessage = function(event) {
            dataDistributor($.parseJSON(event.data));
          };
          
          // Send a keep-alive message to the server every 30 seconds.
          setInterval(function() {
            ws.send("keep-alive");
          }, 30000);
          
          return ws;
        }
        catch (failure) {
        }
      },
  
      /**
       * Create a WebSocket for receiving real-time chat.
       * @param dataDistributor
       */
      createChatSocket = function (dataDistributor) {
        return createSocket(window.location.host + "/api/chatting", "chatting", dataDistributor);
      },
  
  
      /************************************************
       ************************************************
       *              Render Functions                *
       ************************************************
       ************************************************/
      
      /**
       * Renders a partial-template to the chat area with the given data.
       */
      renderChat = function (partialName, data) {
        $("#chat > tbody:last").append(Handlebars.partials[partialName](data));
        $("#chat > tbody").scrollTop($("#chat > tbody")[0].scrollHeight);
      },
  
      /**
       * Prints a message to the channel.
       */
      onMessage = function (data) {
        
        renderChat("message", data);
        
        if (data.notify && !focused) {
          document.title = "[New Message]";
        }
      },
      
      /**
       * Prints a message that we sent to the channel.
       */
      onMyMessage = function (data) {
        
        renderChat("myMessage", data);
        
      },
      
      onPrivateMessage = function (data) {
        
        renderChat("privateMessage", data);
        
      },
      
      onMyPrivateMessage = function (data) {
        
        renderChat("myPrivateMessage", data);
        
      },
      
      /**
       * Print an action to the channel.
       */
      onAction = function (data) {
        
        renderChat("action", data);
        
        if (data.notify && !focused) {
          document.title = "[New Message]";
        }
      },
      
      /**
       * onConnect
       */
      onConnected = function (data) {
        
        renderChat("connect", data);
        
        if (data.notify && !focused) {
          document.title = "[New Message]";
        }
      },
      
      /**
       * onDisconnect
       */
      onDisconnected = function (data) {
        
        renderChat("disconnect", data);
        
        if (data.notify && !focused) {
          document.title = "[New Message]";
        }
      },
  
      /**
       * Updates the list of nicknames and renders that a user has joined to the chat.
       */
      onJoined = function (data) {
        
        renderChat("join", data);
        
        $("#chatters ul").append(Handlebars.partials['userlist'](data));
        
        if (data.notify && !focused) {
          document.title = "[New Message]";
        }
      },
      
      /**
       * Updates the list of nicknames and renders that a user has parted the channel.
       * @param data
       */
      onParted = function (data) {
        
        renderChat("part", data);
        
        if (data.notify && !focused) {
          document.title = "[New Message]";
        }
        
        $("#chatters ul li").each(function(index) {
          if($(this).text() === data.parted) {
            $(this).remove();
            return;
          }
        });
      },
  
      /**
       * Renders a chat line that a user has quit and removes the user from the 
       * list of users.
       * @param data
       */
      onQuit = function (data) {
        
        renderChat("quit", data);
        
        if (data.notify && !focused) {
          document.title = "[New Message]";
        }
        
        $("#chatters ul li").each(function(index) {
          if($(this).text() === data.sourceNick) {
            $(this).remove();
            return;
          }
        });
      },
  
      /**
       * Renders the list of users in this channel.
       * @param data
       */
      onUserlist = function (data) {
        
        $("#chatters ul").html(Handlebars.partials['userlist'](data));
        
      },
  
      /**
       * Renders the newly updated list of nicknames in the channel.
       * @param data
       */
      onNickChange = function (data) {
        
        renderChat("nickChange", data);
        
        if (data.notify && !focused) {
          document.title = "[New Message]";
        }
        
        $("#chatters ul li").each(function(index) {
          if($(this).text() === data.oldNick) {
            $(this).text(data.newNick);
            return;
          }
        });
      },
      
      /**
       * Initializes the chat class.
       */
      init = function () {
        
        distributor = createDataDistributor({
            "connected": onConnected,
            "disconnected": onDisconnected,
            "parted": onParted,
            "joined": onJoined,
            "message": onMessage,
            "myMessage": onMyMessage,
            "privateMessage" : onPrivateMessage,
            "myPrivateMessage" : onMyPrivateMessage,
            "action": onAction,
            "userlist": onUserlist,
            "nickchange": onNickChange,
            "quit": onQuit
          });
          
        window.addEventListener('focus', function(e) {
          if (document.title !== startingTitle) {
            document.title = startingTitle;
            focused = true;
          }
          $("#chatInput").focus();
        });
        
        window.addEventListener('blur', function() {
          focused = false;
        });
        
        window.addEventListener('keydown', function(e) {
          var chatInput = $("#chatInput").val(),
              keyCode = e.keyCode || e.which,
              i,
              currentWord, currentUser;
          
          // This detects the pressing of the tab key to try and auto-fill
          // a user's name.
          if(keyCode === 9 && !e.ctrlkey) {                
            e.preventDefault();
            
            $("#chatInput").focus();
            
            chatInput = chatInput.split(" ");
            currentWord = chatInput[chatInput.length - 1];
            currentWord = currentWord.toLowerCase();

            if(currentWord.trim() !== '') {
              $("#chatters ul li").each(function() {
                if($(this).html().toLowerCase().indexOf(currentWord) === 0) {
                  chatInput[chatInput.length - 1] = $(this).html();
                  $("#chatInput").val(chatInput.join(" "));
                  return;
                }
              });
            }
          }
        });

        window.onbeforeunload = function(event) {              
          return 'Closing or reloading will close the IRC connection.';
        };
        
        distributor();
        
        webSocket = createChatSocket(distributor);
        
        $("#chatInput").keypress(function(e) {
          var chatInput = $("#chatInput").val(),
              keyCode = e.keyCode || e.which;
          
          // This detects the pressing of the enter key and overrides its
          // default implementation in favor of pushing the text over the
          // websocket and then clearing the text field.
          if(keyCode === 13 && chatInput !== null && 
              chatInput !== undefined && chatInput.trim() !== '') {
            e.preventDefault();
            webSocket.send(chatInput);
            $("#chatInput").val('');
          }
        });
        
//        $("#chatInput").blur(function() {
//          setTimeout(function() {
//            $("#chatInput").focus();
//          },0);
//        });
      };

  // -------------------------------------------- //
  //                 Public methods               //
  // -------------------------------------------- //

  $.when( $.ajax("/api/chat/data") ).then( function(data) {
    tc.Templater.render(data, init);
  });
}());
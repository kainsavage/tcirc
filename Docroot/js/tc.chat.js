  $(function () {
      'use strict';
      // -------------------------------------------- //
      //               Private variables              //
      // -------------------------------------------- // 
      var focused,
          distributor = null,
          webSocket = null,
          startingTitle = document.title,
          userList = [],
  
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
            return createSocket("localhost:9999/chatting", "chatting", dataDistributor);
          },
      
      
          /************************************************
           ************************************************
           *              Render Functions                *
           ************************************************
           ************************************************/
      
          /**
           * Simply prints a line to the chat console with the given data payload.
           */
          printChatLine = function (data) {
            var time = data.time,
                sender = data.sender,
                who = data.who,
                notify = data.notify;
            
            if (sender === null || sender === undefined) {
              sender = "";
            }
            
            if (time === null || time === undefined) {
              time = "";
            }
            
            if (who === null || who === undefined) {
              who = "who";
            }
            
            if (notify === null || notify === undefined) {
              notify = false;
            }
            
            $("#chat > tbody:last").append('<tr><td class="time">' + time + '</td><td class="' + who + '">' + sender + '</td><td class="text">' + data.message + '</td></tr>');
            $("#chat > tbody").scrollTop($("#chat > tbody")[0].scrollHeight);
            
            if (notify && !focused) {
              document.title = "[New Message]";
            }
          },
      
          /**
           * Renders the list of users in this channel.
           * @param data
           */
          renderUserList = function (data) {
            var i;
            $("#chatters ul").empty();
            userList = [];
            for(i = 0; i < data.nicks.length; i++) {
              $("#chatters ul").append('<li>' + data.nicks[i] + '</li>');
              userList[i] = data.nicks[i];
            }
          },
      
          /**
           * Renders the newly updated list of nicknames in the channel.
           * @param data
           */
          renderNickChange = function (data) {
            var i;
            for(i = 0; i < userList.length; i++) {
              if(userList[i] === data.oldNick) {
                userList[i] = data.newNick;
                break;
              }
            }
            $("#chatters ul li").each(function(index) {
              if($(this).text() === data.oldNick) {
                $(this).text(data.newNick);
                printChatLine(data);
                return;
              }
            });
          },
      
          /**
           * Updates the list of nicknames and renders that a user has joined to the chat.
           * @param data
           */
          renderUserJoined = function (data) {
            $("#chatters ul").append('<li>' + data.joiner + '</li>');
            userList[userList.length] = data.joiner;
            printChatLine(data);
          },
          
          /**
           * Updates the list of nicknames and renders that a user has parted the channel.
           * @param data
           */
          renderUserParted = function (data) {
            var i, tempUserList = [];
            for(i = 0; i < userList.length; i++) {
              if(userList[i] !== data.parted) {
                tempUserList[length] = userList[i];
              }
              userList = tempUserList;
            }
            $("#chatters ul li").each(function(index) {
              if($(this).text() === data.parted) {
                $(this).remove();
                printChatLine(data);
                return;
              }
            });
          },
      
          /**
           * Renders a chat line that a user has quit and removes the user from the 
           * list of users.
           * @param data
           */
          renderUserQuit = function (data) {
            var i, tempUserList = [];
            for(i = 0; i < userList.length; i++) {
              if(userList[i] !== data.sourceNick) {
                tempUserList[length] = userList[i];
              }
              userList = tempUserList;
            }
            $("#chatters ul li").each(function(index) {
              if($(this).text() === data.sourceNick) {
                $(this).remove();
                printChatLine(data);
                return;
              }
            });
          },
          
          /**
           * Initializes the chat class.
           */
          init = function () {
            distributor = createDataDistributor({
                "connected": printChatLine,
                "disconnected": printChatLine,
                "parted": renderUserParted,
                "joined": renderUserJoined,
                "message": printChatLine,
                "action": printChatLine,
                "userlist": renderUserList,
                "nickchange": renderNickChange,
                "myMessage": printChatLine,
                "quit": renderUserQuit
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
                  for(i = 0; i < userList.length; i++) {
                    currentUser = userList[i];
                    currentUser = currentUser.toLowerCase();
                    
                    if(currentUser.indexOf(currentWord) === 0) {
                      chatInput[chatInput.length - 1] = userList[i];
                      $("#chatInput").val(chatInput.join(" "));
                      return;
                    }
                  } 
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
            
//            $("#chatInput").blur(function() {
//              setTimeout(function() {
//                $("#chatInput").focus();
//              },0);
//            });
          };
    
      // -------------------------------------------- //
      //                 Public methods               //
      // -------------------------------------------- //
    
      init();
  }());
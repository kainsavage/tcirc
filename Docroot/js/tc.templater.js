tc.Templater = tc.Templater || (function($) {
  'use strict';
  var templates = {},
      inProgress = {},
      queue = {},
      partialsQueue = 0,
      errorCallback,
      qualifyFileCallback;
 
  /**
   * If either a request specific or global error handler function has been
   * defined, call it with the filename.
   *
   * @param {!string} fileName
   * @param {function(string)=} requestErrorCallback
   */
  function runErrorCallback(fileName, requestErrorCallback) {
    if ($.isFunction(requestErrorCallback) === true) {
      requestErrorCallback(fileName);
    } else if ($.isFunction(errorCallback) === true) {
      errorCallback(fileName);
    }
  }
 
  /**
   * If a template is currently being loaded, this adds a callback to the queue
   * of callbacks to be called once the template is loaded.
   *
   * @param fileName
   *          the template that is currently being loaded.
   * @param callback
   *          the callback function to call with this template once the template
   *          is loaded.
   */
  function pushToQueue(fileName, callback) {
    if (queue[fileName] === undefined) {
      queue[fileName] = [];
    }
    queue[fileName].push(callback);
  }
 
  /**
   * This should be called once a template has been successfully loaded.
   *
   * <p>
   * This processes all callbacks for this template and clears them from the
   * queue.
   *
   * <p>
   * If the template has not been loaded when this is called, the queue will
   * remain untouched.
   */
  function processQueue(fileName) {
    var currentQueue;
    if (queue[fileName] !== undefined) {
      currentQueue = queue[fileName];
      queue[fileName] = [];
      $.each(currentQueue, function() {
        var callback = this;
        getTemplate(fileName, callback);
      });
    }
  }
 
  /**
   * If a qualifyFileCallback function has been defined, calls that to get a
   * qualified and/or versioned template url.
   */
  function getTemplateUrl(fileName) {
    if ($.isFunction(qualifyFileCallback) === true) {
      return qualifyFileCallback(fileName);
    }
    return fileName;
  }
 
  /**
   * This function gets a template and passes it to the callback function
   * parameter. Multiple calls to this function for the same template will
   * result in only one ajax request for the template file. Multiple calls are
   * put into a queue until the template is loaded.
   *
   * @param {!string} fileName
   * @param {!function(Object)} callback
   * @param {function(string)=} failure
   *          If the ajax request to load the template failed, this callback
   *          function is called. If there is one request in progress and
   *          multiple requests queued, only the request that actually performs
   *          the ajax request triggers the failure function.
   */
  function getTemplate(fileName, callback, failure) {
    var skipPartialsCheck = (arguments[3] === true);
    if (templates[fileName] !== undefined) {
      callback(templates[fileName]);
      return;
    }
    if (partialsQueue > 0 && skipPartialsCheck !== true) {
      pushToQueue(fileName, callback);
      return;
    }
    // Template loading in progress, so push to queue
    if (inProgress[fileName] === true) {
      pushToQueue(fileName, callback);
      return;
    }
    // Request to load the template for a first time, so we'll perform an
    // ajax request to grab the template.
    inProgress[fileName] = true;
    $.ajax({
      url : getTemplateUrl(fileName),
      cache : true,
      timeout : 5000,
      tryCount : 0,
      retryLimit : 10,
      success : function(data) {
        if (templates[fileName] === undefined) {
          templates[fileName] = Handlebars.compile(data);
        }
        inProgress[fileName] = false;
        callback(templates[fileName]);
        // Process all the queued callbacks for this template now that the
        // template is loaded.
        processQueue(fileName);
      },
      // On error, this request is retried a set number of times.
      error : function() {
        // jquery bug workaround pre jquery 1.5
        // (http://bugs.jquery.com/ticket/7461)
        this.context = undefined;
 
        this.tryCount = this.tryCount + 1;
        // Double the timeout each time to account for slow connections
        this.timeout *= 2;
        // We'll retry this request tryCount times
        if (this.tryCount <= this.retryLimit) {
          $.ajax(this);
          return;
        }
        // Ok, looks like we couldn't load the template, despite multiple
        // tries. Call the error callback function.
        runErrorCallback(fileName, failure);
        inProgress[fileName] = false;
        return;
      }
    });
  }
 
  /**
   * If there is an error loading a template, this function will be called. The
   * callback function will be passed in the template file name as its first
   * argument.
   *
   * <p>
   * Note that this is overridden if an error callback function is passed to
   * getTemplate. This is basically the default error handler function.
   *
   * <p>
   * Passing in undefined, null, etc will cause a template loading error to
   * basically be silently ignored.
   */
  function setErrorCallbackFunction(callback) {
    errorCallback = callback;
  }
 
  /**
   * This function will be called before performing an ajax request for a
   * template. This function should generally take a relative path/file name and
   * make it absolute (by prepending something like '/images/' for example).
   * This might also be responsible for appending a versioning string.
   *
   * <p>
   * If this is not defined, you will need to pass in fully qualified file names
   * to the getTemplate function.
   *
   * @param {function(string)} callback
   */
  function setQualifyFileCallbackFunction(callback) {
    qualifyFileCallback = callback;
  }
 
  /**
   * Since templates are loaded asynchronously, you must use this to register a
   * partial instead of directly through Handlebars.
   *
   * @param {!string} name
   * @param {!string} fileName
   * @param {function(string)=} failure
   */
  function registerPartial(name, fileName, failure) {
    partialsQueue += 1;
    getTemplate(fileName, function(template) {
      Handlebars.registerPartial(name, template);
      partialsQueue -= 1;
      if (partialsQueue === 0) {
        $.each(queue, function(key) {
          processQueue(key);
        });
      }
    }, failure, true);
  }
 
  function render(data, callback) {
    var baseTemplate = null;
    
    // Let's iterate over all our 'text/partial' script-types
    $("script[type*=partial]").each(function() {
      var id = this.id,
          src = this.src;
      registerPartial(id, src);
    });
    
    baseTemplate = $("script[type*=template]")[0];
    
    if (baseTemplate === null || baseTemplate === undefined) {}
    else {
      getTemplate(baseTemplate.src, function(compiledTemplate) {
        if (callback) {
          $.when($('body').html(compiledTemplate(data))).then(callback()); 
        }
        else {
          $('body').html(compiledTemplate(data));
        }
      });
    }
  }
 
  // Define which functions should be public
  return {
    render : render,
    getTemplate : getTemplate,
    setErrorCallbackFunction : setErrorCallbackFunction,
    setQualifyFileCallbackFunction : setQualifyFileCallbackFunction,
    registerPartial : registerPartial
  };
 
}(jQuery));
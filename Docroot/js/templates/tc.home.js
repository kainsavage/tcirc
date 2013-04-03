/**
 * This is the controller code for the home page.
 */
$(function(){
  var data = { headerName: "TCIRC Home" };
  
  /**
   * afterRendering is a callback from the render method on the tc.Templater.
   * Since rendering templates is handle asynchronously, this is how we need
   * to handle performing controller code against the template-built DOM. 
   */
  function afterRendering () {
    // Without this function being a callback from render, this call to add
    // a submit listener on the form would not work because at this stage
    // (regardless of whether render is called first or not) the form is not
    // in the DOM.
    $("form").submit(function(e) {
      $.post('/api/connect', $("form").serialize()).done(function(response) {
        if(response.success) {
          window.location = response.success;
        }
        else {
          var newData = $.extend({}, data, response);
          console.log(newData);
          tc.Templater.render(newData, afterRendering);
        }
      });
      
      return false;
    });
  }
  
  $.when( data ).then( function(data) {
    tc.Templater.render(data, afterRendering);
  });
});
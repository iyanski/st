//= require jquery
//= require jquery_ujs

$(document).ready(function() {
  'use strict';
  $(document).on("click", ".signin", function(e){
    e.preventDefault();
  });
  
  $("#new_customer_session").on("ajax:success", function(e, data, status, xhr) {
    var err = "Invalid Email or Password";
    try
    {
      var response = JSON.parse(xhr.responseText);
      if (response.token) {
        location.href = "/app";
      } else {
        $(".alert.alert-warning").removeClass("hide").html(err);
      }
    }
    catch(e)
    {
      $(".alert.alert-warning").removeClass("hide").html(err);
    }
  });

  $("#new_customer").on("ajax:success", function(e, data, status, xhr) {
    // location.href = "/app";
  }).on("ajax:error", function(e, xhr, status, error) {
    try
    {
       var response = JSON.parse(xhr.responseText);
       var message = response.error;
    }
    catch(e)
    {
       var message = xhr.responseText;
    }
    $(".alert.alert-warning").removeClass("hide").html(message);
  });

  $("#new_user_session").on("ajax:success", function(e, data, status, xhr) {
    var err = "Invalid Email or Password";
    try
    {
      var response = JSON.parse(xhr.responseText);
      if (response.token) {
        location.href = "/admin";
      } else {
        $(".alert.alert-warning").removeClass("hide").html(err);
      }
    }
    catch(e)
    {
      $(".alert.alert-warning").removeClass("hide").html(err);
    }
  }).on("ajax:error", function(e, xhr, status, error) {
    console.log(error);
  });

  $("#new_user").on("ajax:success", function(e, data, status, xhr) {
    location.href = "/admin";
  }).on("ajax:error", function(e, xhr, status, error) {
    try
    {
       var response = JSON.parse(xhr.responseText);
       var message = response.error;
    }
    catch(e)
    {
       var message = xhr.responseText;
    }
    $(".alert.alert-warning").removeClass("hide").html(xhr.responseText);
  });

  $("#new_expert_session").on("ajax:success", function(e, data, status, xhr) {
    var err = "Invalid Email or Password";
    try
    {
      var response = JSON.parse(xhr.responseText);
      if (response.token) {
        location.href = "/dashboard";
      } else {
        $(".alert.alert-warning").removeClass("hide").html(err);
      }
    }
    catch(e)
    {
      $(".alert.alert-warning").removeClass("hide").html(err);
    }
  });

  $("#new_expert").on("ajax:success", function(e, data, status, xhr) {
    location.href = "/dashboard";
  }).on("ajax:error", function(e, xhr, status, error) {
    try
    {
       var response = JSON.parse(xhr.responseText);
       var message = response.error;
    }
    catch(e)
    {
       var message = xhr.responseText;
    }
    $(".alert.alert-warning").removeClass("hide").html(xhr.responseText);
  });
});
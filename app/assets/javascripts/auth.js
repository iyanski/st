//= require jquery
//= require jquery_ujs

$(document).ready(function() {
  'use strict';
  $("#new_customer").on("ajax:success", function(e, data, status, xhr) {
    location.href = "/app";
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
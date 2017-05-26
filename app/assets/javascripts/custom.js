/* ============================================================
 * Plugin Core Init
 * For DEMO purposes only. Extract what you need.
 * ============================================================ */
$(document).ready(function() {
    'use strict';
    //Intialize Slider
    var slider = new Swiper('#hero', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev',
        slidesPerView: 1,
        parallax: true,
        speed: 1000,
    });

    //Intialize Testamonials
    var testimonials_slider = new Swiper('#testimonials_slider', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        nextButton: '.swiper-button-next',
        prevButton: '.swiper-button-prev',
        parallax: true,
        speed: 1000
    });

    // Initialize Search
    $('[data-pages="search"]').search({
        // Bind elements that are included inside search overlay
        searchField: '#overlay-search',
        closeButton: '.overlay-close',
        suggestions: '#overlay-suggestions',
        brand: '.brand',
        // Callback that will be run when you hit ENTER button on search box
        onSearchSubmit: function(searchString) {
            console.log("Search for: " + searchString);
        },
        // Callback that will be run whenever you enter a key into search box. 
        // Perform any live search here.  
        onKeyEnter: function(searchString) {
            console.log("Live search for: " + searchString);
            var searchField = $('#overlay-search');
            var searchResults = $('.search-results');

            /* 
                Do AJAX call here to get search results
                and update DOM and use the following block 
                'searchResults.find('.result-name').each(function() {...}'
                inside the AJAX callback to update the DOM
            */

            // Timeout is used for DEMO purpose only to simulate an AJAX call
            clearTimeout($.data(this, 'timer'));
            searchResults.fadeOut("fast"); // hide previously returned results until server returns new results
            var wait = setTimeout(function() {

                searchResults.find('.result-name').each(function() {
                    if (searchField.val().length != 0) {
                        $(this).html(searchField.val());
                        searchResults.fadeIn("fast"); // reveal updated results
                    }
                });
            }, 500);
            $(this).data('timer', wait);

        }
    });
    function validateEmail(email) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }

    $(document).on("click", "[data-start='email']", function(e){
      
      if(validateEmail($('input#email-registration').val())){
        $("#getstarted").modal("show");
        $('#email-address').val($('input#email-registration').val());
      } else {
        alert("Invalid Email Address");
      }
    });
    
    $(document).on("keypress", "#email-registration", function(e){
      if(e.keyCode == 13){
        if(validateEmail($('input#email-registration').val())){
          $("#getstarted").modal("show");
          $('#email-address').val($('input#email-registration').val());
        } else {
          alert("Invalid Email Address");
        }
      }
    })

    $(document).on("submit", "form#setup", function(e){
        e.preventDefault();
        $("em.auth.small").addClass("hidden");
        var request = $.ajax({
            url: "/companies",
            method: "post",
            data: {
                email: $('input#email-address').val(),
                password: $('input#password').val(),
                subdomain: $('input#subdomain').val()
            },
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            success: function(data, xhr){
                $("#getstarted").modal("hide");
                setTimeout(function(){
                    location.href = location.protocol + '//' + data.domain + "/companies/continue";
                }, 100);
            },
            error: function(data, status){
                var response = JSON.parse(data.responseText);
                console.log(response);
                if(response.error && response.error.length){
                    $("em.small.password").removeClass("hidden").html(response.error);
                }
                for(var item in response){
                    if(response[item].email && response[item].email.length){
                        $("em.small.email").removeClass("hidden").html(response[item].email);
                    }
                    if(response[item].subdomain && response[item].subdomain.length){
                        $("em.small.subdomain").removeClass("hidden").html(response[item].subdomain);
                    }
                }
            }
        });
    });
});
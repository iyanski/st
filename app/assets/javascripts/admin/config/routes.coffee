@app.config ["$routeProvider", "$locationProvider", "$httpProvider",

  ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when "/",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-dashboard"
        activemenu: "page-dashboard"

      .when "/jobs",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-home"
        activemenu: "page-home"

      .when "/job/:id",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-home"
        activemenu: "page-home"

      .when "/services",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-services"
        activemenu: "page-services"

      .when "/services/new",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-form-services"
        activemenu: "page-services"

      .when "/service/:id",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-form-services"
        activemenu: "page-services"

      .when "/people",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-people"
        activemenu: "page-people"

      .when "/customer/:id",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-customer"
        activemenu: "page-people"

      .when "/expert/:id",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-expert"
        activemenu: "page-people"

      .when "/experts/new",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-form-experts"
        activemenu: "page-people"

      .when "/storefront",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-store"
        activemenu: "page-store"

      .when "/transactions",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-transactions"
        activemenu: "page-transactions"

      .when "/tickets",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-tickets"
        activemenu: "page-tickets"

      .otherwise redirectTo: '/'
]
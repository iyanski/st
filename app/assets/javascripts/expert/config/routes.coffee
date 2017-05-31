@app.config ["$routeProvider", "$locationProvider", "$httpProvider",

  ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when "/",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-home"
        activemenu: "page-home"

      .when "/job/:id",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-home"
        activemenu: "page-home"

      .when "/settings",
        templateUrl: "common.html"
        controller: "settingsPageCtrl"
        activepage: "page-settings"
        activemenu: "page-settings"

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

      .when "/ticket/:id",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-tickets"
        activemenu: "page-tickets"

      .otherwise redirectTo: '/'
]
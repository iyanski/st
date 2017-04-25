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
        controller: "rootPageCtrl"
        activepage: "page-people"
        activemenu: "page-people"

      .when "/experts/new",
        templateUrl: "common.html"
        controller: "rootPageCtrl"
        activepage: "page-form-experts"
        activemenu: "page-experts"

      .otherwise redirectTo: '/'
]
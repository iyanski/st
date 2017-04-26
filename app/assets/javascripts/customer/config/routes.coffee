@app.config ["$routeProvider", "$locationProvider", "$httpProvider",

  ($routeProvider, $locationProvider, $httpProvider) ->
    $routeProvider
      .when "/",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-home"

      .when "/&gid=:gid&pid=:pid",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-home"

      .when "/job/:id",
        templateUrl: "common.html"
        controller: "homePageCtrl"
        activepage: "page-home"

      .when "/settings",
        templateUrl: "common.html"
        controller: "settingsPageCtrl"
        activepage: "page-settings"

      .otherwise redirectTo: '/'
]
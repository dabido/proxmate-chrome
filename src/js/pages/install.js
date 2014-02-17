// Generated by CoffeeScript 1.7.1
(function() {
  'use strict';
  angular.module('proxmateApp', ['ngRoute']).config(function($locationProvider, $routeProvider) {
    $locationProvider.hashPrefix('!');
    return $routeProvider.when('/', {
      templateUrl: 'views/main.html',
      controller: 'MainCtrl'
    }).when('/install/:packageId', {
      templateUrl: 'views/install.html',
      controller: 'InstallCtrl'
    }).otherwise({
      redirectTo: '/'
    });
  });

  angular.module('proxmateApp').controller('MainCtrl', ['$scope', '$route', '$routeParams', function($scope) {}]);

  angular.module('proxmateApp').controller('InstallCtrl', [
    '$scope', '$route', '$routeParams', function($scope, $route, $routeParams) {
      return $scope.asdf = 123;
    }
  ]);

}).call(this);

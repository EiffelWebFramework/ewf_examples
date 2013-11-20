var TODOApp = angular.module ('TODOApp',['ngResource']);


TODOApp.config(function($routeProvider, $locationProvider,$httpProvider) {
  $routeProvider
    .when('/', {controller: ListCtrl, templateUrl: '/partials/list.html'})
	.when('/edit/:id', {controller: EditCtrl, templateUrl: '/partials/details.html'})
	.when('/new', {controller: CreateCtrl, templateUrl: '/partials/details.html'})	
    .otherwise({redirectTo: '/'});
   $locationProvider.html5Mode(true);
});

TODOApp.factory('TodoService', function($resource) {
  return $resource('/tasks/:id', {id: '@id'}, {update: {method: 'PUT'}});
  });


function ListCtrl ($scope, TodoService){
	var index = -1;
	$scope.todos = TodoService.query();
	
	$scope.index = index; //currently selected element
	
	$scope.select = function (i){
		$scope.index = index;
		index = i;
		$scope.selectedId = $scope.todos[index].id;
	}

	$scope.delete = function (){
		if (index >= 0) {
			TodoService.delete ({id:$scope.todos[index].id})
			$scope.todos.splice(index,1)
		}
	}
	
	
}



function EditCtrl ($scope, $location, $routeParams,TodoService) {

 $scope.get = TodoService.get({id: $routeParams.id}, function(data,headers) {
		$scope.todo = data.content;
		$scope.ifmatch = headers().etag; 	  
	  });

 
  $scope.action = 'Update';
  $scope.save = function() {
    TodoService.update({id: $routeParams.id},{headers:{'if-match':$scope.ifmatch}},$scope.todo, function() {
      $location.path('/');
    })
  }
};

function CreateCtrl ($scope, $location, TodoService) {
  
  $scope.action = 'Add';
 
  $scope.save = function() {
    TodoService.save($scope.todo, function() {
      $location.path('/');
    })
  };
};

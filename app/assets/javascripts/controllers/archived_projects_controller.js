angular.module("OpenHq").controller("ArchivedProjectsController", function($scope, $routeParams, $location, Project, ProjectsRepository) {
  Project.query({archived: true}).then(function(projects) {
    $scope.archived_projects = projects;
  });

  $scope.restoreProject = function(project) {
    ProjectsRepository.restore(project.slug).then(function(project){
      // TODO: add a notification
      $location.url('/projects/'+project.slug);
    });
  };
});
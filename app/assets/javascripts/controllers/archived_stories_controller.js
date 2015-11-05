angular.module("OpenHq").controller("ArchivedStoriesController", function($scope, $routeParams, Project, Story, StoriesRepository) {
  Project.get($routeParams.slug).then(function(project) {
    $scope.project = project;
  });

  Story.query({project_id: $routeParams.slug, archived: true}).then(function(stories) {
    $scope.archived_stories = stories;
  });

  $scope.restoreStory = function(story) {
    StoriesRepository.restore(story.slug).then(function(resp){
      console.log(resp);
    });
  };
});

namespace = angular.module('itemSetView', [])

namespace.controller("itemSetViewController", ['$scope', ($scope) ->
  $('.item').tooltip(
    html: true
  )

  $scope.syntaxHighlight = () ->
    SyntaxHighlighter.highlight()
  ]
)

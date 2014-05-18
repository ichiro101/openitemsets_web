
namespace = angular.module('itemSetView', [])

namespace.controller("itemSetViewController", ['$scope', ($scope) ->
  $scope.syntaxHighlight = () ->
    SyntaxHighlighter.highlight()
  ]
)

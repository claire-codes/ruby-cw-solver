var app = angular.module('plunker', []);

app.directive('clueBox', function() {
    return {
        restrict: 'E',
        template: '<div class="box my-show-hide-animation">'
        + '<input name="clueInput" type="text" class="letter" maxlength=1 ng-model="clueLetters[$index].letter" tabindex="{{$index+1}}" ng-change="moveBox($index)"/>'
        + '<span class="countBox">{{$index+1}}</span>'
        + '<button type="button" class="deleteBox" ng-click="removeBox($index)" tabindex="0">X</button>'
        + '</div>'
    };
});

app.controller('RegexCtrl', function($scope, $log, $http) {

    $scope.noContent = false;
    $scope.foo="bar";

    /** Move to next box after one character is input */
    $scope.moveBox = function(index) {
        var boxes = document.getElementsByClassName('squareInput');
        var submit = document.getElementById('submitButton');
        var inputLength = boxes[index].value.length;
        if ((index < boxes.length -1)) {
            if (inputLength >= 1) {
                var next = boxes[index + 1];
                next.focus();
            }
            // Else leave it where it is
        } else {
            submit.focus();
        }
    };

    $scope.wordList = ["dog", "Dog", "DOG", "dogg", "mrdog", "Mr. Dog", "god", "*dog*", "xabc", "xxabc", "abcx", "abcy", "abcxx", "abcxabc", "abcxxabc", "xabcxabcx", "abc", ""];

    // Do Ajax stuff to obtain external wordList.
    /*$http.get("wordList.json")
     .success(function(data) {
     $scope.wordList = data;
     })
     .error(function(data) {
     $log.error("Nope");
     });*/

    $scope.regex = "";

    $scope.INITIAL_MODEL = [{
        "letter": ""
    }, {
        "letter": ""
    }, {
        "letter": ""
    }, {
        "letter": ""
    }, {
        "letter": ""
    }];

    // Set up default model.
    $scope.clueLetters = angular.copy($scope.INITIAL_MODEL);

    // Focus automatically onto the first input box - won't work
    // var boxes = document.getElementsByClassName('squareInput');
    // boxes[0].focus();

    $scope.submitIndex = $scope.clueLetters.length;

    // Set up empty list of matching elements.
    $scope.matchBox = [];

    // A box can be inserted with a directive.
    // Each clue letter is an entry in an array.
    $scope.addBox = function() {
        var newLetter = {
            "letter": ""
        };
        var maxBoxLimit = 8;
        if ($scope.clueLetters.length < maxBoxLimit) {
            $scope.clueLetters.push(newLetter);
        }
    };

    // Remove boxes by slicing out of model.
    $scope.removeBox = function(ind) {
        // Take the one off the end if not explicitly mentioned.
        console.log(ind);
        var index = ind > -1 ? ind : $scope.clueLetters.length - 1;
        console.log(index);
        var minBoxLimit = 2;
        if ($scope.clueLetters.length > minBoxLimit) {
            $scope.clueLetters.splice(index, 1);
        }
    };

    // Reset screen for new clue
    $scope.restart = function() {
        $scope.clueLetters = angular.copy($scope.INITIAL_MODEL);
        $scope.matchBox = [];
    };

    // Get the input from the user from the separate input boxes and concatenate into a string.
    $scope.getClue = function() {
        // "clue" is the overall string.
        var clue = "";
        // "clueLetters" is the model object.
        $scope.clueLetters.forEach(function(obj) {
            // Unknown letters should be empty boxes.
            if (obj.letter === "") {
                clue += " ";
            }
            // TODO: What if there something other than a letter or a blank?
            clue += obj.letter;
        });
        $scope.clue = clue;
        return clue;
    };


    // We've got out letters from the clue, we've made them into a regex.
    // Now test our regex against our word list and return a list of any matches.
    $scope.processRegex = function(regex) {
        var newRegex = new RegExp(regex, 'i');
        var matchBox = [];
        $scope.wordList.forEach(function(word) {
            if (word.match(newRegex)) {
                matchBox.push(word);
            }
        });
        if (matchBox.length === 0) {
            matchBox.push("No matches!");
        }
        $scope.matchBox = matchBox;
    };

    var convertBlanks = function(total) {
        // Validate content first.
        return ".{" + total.toString() + "}";
    };


    // Convert clue box input string to a regex by converting spaces to unknown chars (periods)
    $scope.toRegex = function(convertThis) {
        // Treat @ as blank space
        // @ -> .{1}
        // @@ -> .{2}
        // n@ -> .{n}
        // Process string, counting blanks as you go
        var regex = "^";
        var isBlank = function(char) {
            if (char === " ") {
                return true;
            } else {
                return false;
            }
        };
        var blankCount = 0;
        var charCount = 0;
        var wordLength = convertThis.length;
        while (charCount < wordLength) {
            var currentChar = convertThis[charCount];
            if (isBlank(currentChar)) {
                blankCount++;
            } else {
                if (blankCount > 0) {
                    regex += convertBlanks(blankCount);
                    blankCount = 0;
                    regex += currentChar;
                } else {
                    regex += currentChar;
                }
            }
            charCount++;
        }
        if (blankCount > 0) {
            regex += convertBlanks(blankCount);
        }
        regex += '$';
        $scope.newRegex = regex;
        return regex;
    };

    // The function executed on "Submit": a combination of all functions above.
    $scope.findMatches = function() {
        var allInputs = document.querySelectorAll('input[name=clueInput]');
        var containsChars = false;
        for (var i = 0; i < allInputs.length; i++ ) {
            if (/^\w$/i.test(allInputs[0])) {
                containsChars = true;
            }
        }
        if (containsChars) {
            $scope.processRegex($scope.toRegex($scope.getClue()));
        } else {
            $scope.noContent = true;
        }
    };
});
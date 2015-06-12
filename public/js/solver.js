var clearErrors = function() {
    $('#errorMsg').hide();
    $('#errorMsg').empty();
};

var addErrorMsg = function(msg) {
    $('#errorMsg').append('<div>' + msg + '</div>');
    $('#errorMsg').show();
};

var clearSolutions = function() {
  $('#results').hide();
  $('#solutions-list').empty();
};

var clearForm = function() {
  $('#clueForm :input.letter').each(function() {
      $(this).val("");
  });
    while ($('div.box').length != 5) {
        if ($('div.box').length > 5) {
            $('div.box').slice(-1).remove();
        } else {
            $('div.clue-container').append('<div class="box"><input type="text" class="letter" name="clueLetter" /></div>');
        }
    }
};

$('#removeBox').click(function() {
    clearErrors();
    if ($('div.box').length > 3) {
        $('div.box').slice(-1).remove();
    } else {
        addErrorMsg('Error: cannot submit words shorter than 3 characters');
    }
});

$('#addBox').click(function() {
    clearErrors();
    if ($('div.box').length < 8) {
        $('div.clue-container').append('<div class="box"><input type="text" class="letter" name="clueLetter" /></div>');
    } else {
        addErrorMsg('Error: cannot submit words longer than 8 characters');
    }
});

$('#restart').click(function() {
    clearErrors();
    clearSolutions();
    clearForm();
});

$('#solveClue').click(function() {
    clearErrors();
    clueArray = [];
    // validate input before posting
    var isBlankSubmission = true;
    var noErrors = true;
    $('#clueForm :input.letter').each(function() {
        var letter = $(this).val().trim();
        if (letter.length == 0) {
            clueArray.push(" ");
        } else if (letter.length > 1) {
            // don't allow
            addErrorMsg("Error: only one letter per box");
            noErrors = false;
        } else if (!/^[a-zA-Z]$/i.test(letter)) {
            // don't mind whitespace
            // it's not a letter so don't allow
            addErrorMsg("Error: not a letter");
            noErrors = false;
        } else {
            clueArray.push($(this).val());
            isBlankSubmission = false;
        }
    });
    // double-check no blank submission
    if (isBlankSubmission) {
        addErrorMsg("Error: must submit at least one letter");
    } else if (noErrors) {
        $.post("answer", {clue: clueArray}, function (data) {
            jsonData = $.parseJSON(data);
            console.log("Response is: " + data);
            console.log("Json is: " + jsonData);
            if (jsonData.length == 0) {
                $("#solutions-list").append('<li>Sorry there are no solutions</li>');
            } else {
                $.each(jsonData, function (ind, solution) {
                    $("#solutions-list").append('<li>' + solution + '</li>');
                });
            }
            $('#results').show();
        })
            .error(function () {
                addErrorMsg('<li>Error: no matching words</li>');
            });
    }
});
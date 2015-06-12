@javascript
Feature: User submits a word and sees a solution

  Scenario: Receive a response from the backend
    Given I am on the home page
    And the word list contains "cat,cap,cats,ca"
    When I enter the clue "ca "
    And I click the "Solve" button
    Then I should see the solutions "cat,cap"
    And I should not see the solutions "cats,ca"

  Scenario: Remove a box
    Given I am on the home page
    And I should see 5 div element with ".box" CSS
    When I click the "-" button
    Then I should see 4 div element with ".box" CSS

  Scenario: Add a box
    Given I am on the home page
    And I should see 5 div element with ".box" CSS
    When I click the "+" button
    Then I should see 6 div element with ".box" CSS

  Scenario: Disallow blank submission
    Given I am on the home page
    And I click the "Solve" button
    Then I should see "Error: must submit at least one letter"
    And I should not see "Solutions"

  Scenario: Disallow ore than one letter per box
    Given I am on the home page
    When I enter the letters "ca,a,t,c," in the boxes
    And I click the "Solve" button
    Then I should see "Error: only one letter per box"
    And I should not see "Solutions"

  Scenario: Disallow numbers or special characters in box
    Given I am on the home page
    When I enter the clue "3 d"
    And I click the "Solve" button
    Then I should see "Error: not a letter"
    And I should not see "Solutions"

  Scenario: Allow single white spaces instead of blank
    Given I am on the home page
    And the word list contains "cat,cap,cats,ca,catch"
    When I enter the letters "c, ,t,c,h" in the boxes
    And I click the "Solve" button
    Then I should not see any error messages
    And I should see the solutions "catch"

  Scenario: Reset button should clear errors and form fields
    Given I am on the home page
    And I click the "-" button
    And I enter the letters "ca,a,t,c" in the boxes
    And I click the "Solve" button
    And I should see "Error: only one letter per box"
    When I click the "Restart" button
    Then I should not see any error messages
    And I should see 5 boxes
    And all the boxes should be clear

  Scenario: Reset button should clear solutions and form fields
    Given I am on the home page
    And I click the "+" button
    And I enter the letters "c,,d,i,," in the boxes
    And I click the "Solve" button
    And I should see the solutions "codify"
    When I click the "Restart" button
    Then I should not see any solutions
    And I should see 5 boxes
    And all the boxes should be clear

  Scenario: When there are no solutions for a valid clue we should see a message
    Given I am on the home page
    And I enter the clue "x y x"
    When I click the "Solve" button
    Then I should see the solutions "Sorry there are no solutions"



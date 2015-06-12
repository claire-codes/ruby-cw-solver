Feature: User visits homepage
  As a viewer
  I want to see the homepage of my app
  (basically checking existence of elements on page)

  Scenario: Should see 5 boxes initially
    Given I am on the home page
    Then I should see 5 boxes
    # need a way to test that input is within div?

  Scenario: Must have at least 3 boxes
    Also checks error message is only shown once
    Given I am on the home page
    And I should see 5 boxes
    When I click the "-" button
    And I click the "-" button
    And I click the "-" button
    Then I should see "Error: cannot submit words shorter than 3 characters"
    And I should see 3 boxes
    # should be in another test?
    When I click the "+" button
    Then I should not see "Error: cannot submit words shorter than 3 characters"

  Scenario: Can have maximum of 8 boxes
    Also checks error message is only shown once
    Given I am on the home page
    And I should see 5 boxes
    And I click the "+" button
    And I click the "+" button
    And I click the "+" button
    And I click the "+" button
    Then I should see "Error: cannot submit words longer than 8 characters"
    And I should see 8 boxes
    # should be in another test?
    When I click the "-" button
    Then I should not see "Error: cannot submit words longer than 8 characters"
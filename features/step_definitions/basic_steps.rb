include Rack::Test::Methods

Given(/^I am on the home page$/) do
  visit "/"
end


Then(/^I should see "([^"]*)"$/) do |text|
  page.should have_content(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  page.should_not have_content(text)
end

Then(/^I should see "([^"]*)" in the "([^"]*)" tag$/) do |text, tag|
  page.should have_selector(tag, text: text)
end

Then(/^I should see (.*) (.*) element with "([^"]*)" CSS$/) do |total, tag, css|
  page.should have_css(tag + css, count: total)
end

Then(/^I should see the submit button$/) do
  page.should have_selector(:link_or_button, 'Submit')
end

When(/^I click the "(.*)" button$/) do |button|
  click_button(button)
end

Given /^I wait for (\d+) seconds?$/ do |n|
  sleep(n.to_i)
end

Then(/^I should receive "([^"]*)"$/) do |arg|
  page.post "/answer"
  expect(page.last_response.body).to eq(["Foobar", "barfoo"].to_json)
end

Then(/^the clue should not be submitted$/) do
  # expect(page.last_response).to be_nil
  expect
end

And(/^I should see (\d+) boxes$/) do |total|
  page.should have_selector('input.letter', count: total)
end

Then(/^I should not see any error messages$/) do
  expect(page).not_to have_selector('#errorMsg')
end
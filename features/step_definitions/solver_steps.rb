When(/^I enter the letters "([^"]*)" in the boxes$/) do |letters|
  boxes = page.all(:css, "input.letter")
  letters.split(",").each_with_index do |letter, index|
    boxes[index].set(letter)
  end
end

And(/^I click the submit button$/) do
  click_button("Submit")
end

When(/^I enter the clue "([^"]*)"$/) do |clue|
  total_boxes = page.all(:css, "input.letter").count
  clue_length = clue.length
  if total_boxes > clue_length
    (total_boxes - clue_length).times do
      click_button("-")
    end
  elsif total_boxes < clue_length
    (clue_length - total_boxes).times do
      click_button("+")
    end
  end
  boxes = page.all(:css, "input.letter")
  clue.split("").each_with_index do |letter, index|
    boxes[index].set(letter)
  end
end

When(/^I submit the clue "([^"]*)"$/) do |clue|
  # step "I enter the letters '#{clue}' in the boxes"
  boxes = page.all(:css, "input.letter")
  clue.split(",").each_with_index do |letter, index|
    boxes[index].set(letter)
  end
  click_button("Solve")
end

And(/^the word list contains "([^"]*)"$/) do |words|
  word_list = words.split(",")

end

Then(/^I should see the solutions "([^"]*)"$/) do |solutions|
  solutions_list = solutions.split(",")
  solutions_contents = find('#solutions-list').all('li').collect(&:text)
  expect(solutions_contents).to include(*solutions_list)
end

And(/^I should not see the solutions "([^"]*)"$/) do |solutions|
  solutions_list = solutions.split(",")
  solutions_contents = find('#solutions-list').all('li').collect(&:text)
  expect(solutions_contents).not_to include(*solutions_list)
end

And(/^all the boxes should be clear$/) do
  all_boxes = page.all(:css, "input.letter")
  all_boxes.each do |box|
    expect(box.value).to be_empty
  end
end

Then(/^I should not see any solutions$/) do
  expect(page).not_to have_selector('#solutions')
end
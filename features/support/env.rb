require_relative "../../myapp"

require "Capybara"
require "Capybara/cucumber"
require "rspec"
require "rack/test"

Capybara.app = MyApp

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.default_driver = :selenium
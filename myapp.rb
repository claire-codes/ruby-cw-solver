require "sinatra/base"
require "json"
require_relative "lib/solver"

class MyApp < Sinatra::Base
  get "/" do
    erb :index
  end

  post "/answer" do
    @letter_array = params[:clue] #this is an array of letters
    puts @letter_array.length
    if @letter_array.empty?
      raise ArgumentError.new("Blank submission")
    end
    solver = Solver.new
    answers = solver.solve_clue(@letter_array).to_json
    answers
  end
end
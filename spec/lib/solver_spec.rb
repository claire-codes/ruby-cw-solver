require "spec_helper"

describe Solver do
  let(:solver) {Solver.new}
  subject { solver }

  it "should accept and spit out a word given as an array" do
    expect{ solver.take_input(["c", "a", "t"]) }.to_not raise_error # this tests parameter types
    expect(solver.take_input(["c", "a", "t"])).to eq("cat")
    expect(solver.take_input([" ", "a" "t"])).to eq(" at")
    expect(solver.take_input(["c", "a", " "])).to eq("ca ")
  end

  it "should match against a basic word list" do
    expect(solver.word_list).to include(*["cat", "cap", "lap", "at"])
    expect{ solver.find_matches(/^ca.{1}$/) }.to_not raise_error
    expect(solver.find_matches(/^ca.{1}$/)). to include "cat"
  end

  it "should convert a clue word with spaces to a regex" do
    expect(solver.create_regex("ca ")).to eq(/^ca.{1}$/)
  end

  it "should do the whole thing in one go" do
    # We have a made up dictionary
    expect(solver.solve_clue(["c","a"," "])).to include(*["cat","cap"])
  end

  it "foo" do
    a = [:a, :b, :c]
    b = [:b, :a]
    expect(a).to include(*b)
  end
end
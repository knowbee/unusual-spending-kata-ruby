require "UnusualSpending"

RSpec.describe UnusualSpending::VERSION do
  it "has a version" do
    expect(UnusualSpending::VERSION::SUMMARY).to_not eql(nil)
  end
end
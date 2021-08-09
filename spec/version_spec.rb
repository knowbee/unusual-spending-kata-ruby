require "UnusualSpending"

RSpec.describe UnusualSpending::VERSION do
  it "has a version" do
    expect(UnusualSpending::VERSION::SUMMARY).to eql("unusual_spending 0.1.1")
  end
end
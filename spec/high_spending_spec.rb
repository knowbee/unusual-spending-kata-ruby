require "HighSpendings"


RSpec.describe HighSpendings do
    let(:high_spending) {HighSpendings.new}

  it "#has_high_spending returns false if amount is the same for current and previous month" do
    currentMonthPayments = [{:payment_date => Time.local(2021, 7, 27), :amount => 2000, :category => "Food"}]
    previousMonthPayments = [{:payment_date => Time.local(2021, 6, 26), :amount => 2000, :category => "Food"}]
    expect(high_spending.has_high_spending?( currentMonthPayments, previousMonthPayments)).to eql(false)
  end


  it "#has_high_spending returns true if there is unusual spending" do
    currentMonthPayments = [{:payment_date => Time.local(2021, 7, 27), :amount => 200000, :category => "Food"}]
    previousMonthPayments = [{:payment_date => Time.local(2021, 6, 26), :amount => 2000, :category => "Food"}]
    expect(high_spending.has_high_spending?( currentMonthPayments, previousMonthPayments)).to eql(true)
  end

  it "#get_high_spending_by_category returns high spending by category" do
    currentMonthPayments = [{:payment_date => Time.local(2021, 7, 27), :amount => 7000, :category => "Food"}, {:payment_date => Time.local(2021, 7, 27), :amount => 10000, :category => "Entertainment"}]
    previousMonthPayments = [{:payment_date => Time.local(2021, 6, 26), :amount => 2000, :category => "Food"}, {:payment_date => Time.local(2021, 6, 26), :amount => 1000, :category => "Entertainment"}]
    expect(high_spending.get_high_spending_by_category(currentMonthPayments, previousMonthPayments)).to eql({:food=> 5000, :entertainment => 9000})
  end


  it "#get_high_spending_by_category returns high spending by category for multiple entries" do
    currentMonthPayments = [{:payment_date => Time.local(2021, 7, 27), :amount => 7000, :category => "Food"},{:payment_date => Time.local(2021, 7, 27), :amount => 3000, :category => "Food"}, {:payment_date => Time.local(2021, 7, 27), :amount => 1000, :category => "Food"}, {:payment_date => Time.local(2021, 7, 27), :amount => 500, :category => "Food"},{:payment_date => Time.local(2021, 7, 27), :amount => 10000, :category => "Entertainment"}]
    previousMonthPayments = [{:payment_date => Time.local(2021, 6, 26), :amount => 2000, :category => "Food"}, {:payment_date => Time.local(2021, 6, 26), :amount => 1000, :category => "Entertainment"}]
    expect(high_spending.get_high_spending_by_category(currentMonthPayments, previousMonthPayments)).to eql({:food => 9500, :entertainment => 9000})
  end

  it "#get_high_spending_by_category returns empty array if there are no previous payments" do
    currentMonthPayments = [{:payment_date => Time.local(2021, 7, 27), :amount => 7000, :category => "Food"}]
    previousMonthPayments = [{:payment_date => Time.local(2021, 6, 26), :amount => 2000, :category => "Electricity"}]
    expect(high_spending.get_high_spending_by_category(currentMonthPayments, previousMonthPayments)).to eql({})
  end

  it "#generate_email returns nil when there are no unusual spending" do
    spending = {}
    user_id = nil
    expect(high_spending.generate_email(nil, nil)).to eql(nil)
  end

  it "#generate_email generates an email when the are unusual spending" do
    user_id = 1
    spending = {:food => 3000, :entertainment => 4000}
    expect(high_spending.generate_email(user_id, spending)).to_not eql(nil)  
  end
  
  it "#generate_email generates expected email when there is unusual spending" do
    user_id = 1
    spending = {:food => 1000}
    response = high_spending.generate_email(user_id, spending)
    
    expected_subject = "Hello valued card user ##{user_id}! \n"
    expected_body = "We have detected unusually high spending on your card in these categories:\n* You spent 1000 on Food\nLove, \n The Credit Company"

    expect(response[:subject]).to eql(expected_subject)  
    expect(response[:body]).to eql(expected_body)  
  end

end
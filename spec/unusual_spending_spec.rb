# frozen_string_literal: true
require "UnusualSpending"
require "Payments"
require "HighSpendings"
require "Email"

RSpec.describe UnusualSpending do
  let (:payments_api) { instance_double("PaymentsApi") }
  let(:spendings) { instance_double("HighSpendings") }
  let(:mailer) { instance_double("Email") }

  it "Should not send an email when amount is the same" do
    user_id = 1

    currentMonthPayments = [{:user_id => 1, :payment_date => Time.local(2021, 7, 27), :amount => 2000, :category => "Food"}]
    previousMonthPayments = [{:user_id => 1, :payment_date => Time.local(2021, 6, 26), :amount => 2000, :category => "Food"}]
    allow(payments_api).to receive(:fetch_payments_by_user_id).with(user_id, 7, 2021).and_return(currentMonthPayments, previousMonthPayments)
    allow(spendings).to receive(:has_high_spending?).with(currentMonthPayments, previousMonthPayments).and_return(false)
    expect(mailer).to_not receive(:email).with(user_id, anything, anything)
  end

  it "Should send an email when there is unusual spending" do
    user_id = 1
    body = generate_body(18000, "Food")
    subject = "Unusual spending alert"

    currentMonthPayments = [{:user_id => 1, :payment_date => Time.local(2021, 7, 27), :amount => 20000, :category => "Food"}]
    previousMonthPayments = [{:user_id => 1, :payment_date => Time.local(2021, 6, 26), :amount => 2000, :category => "Food"}]
    allow(payments_api).to receive(:fetch_payments_by_user_id).with(user_id, 7, 2021).and_return(currentMonthPayments, previousMonthPayments)
    allow(spendings).to receive(:has_high_spending?).with(currentMonthPayments, previousMonthPayments).and_return(true)
    expect(mailer).to receive(:email).with(user_id, subject, body).at_most(1).time
  end

  def generate_body(amount, category)
    "We have detected unusually high spending on your card in these categories:\n* You spent #{amount} on #{category}\nLove, \n The Credit Company"
  end
end

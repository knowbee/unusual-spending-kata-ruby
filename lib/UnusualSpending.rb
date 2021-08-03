class UnusualSpending

  attr_accessor :payments_api, :mailer, :spendings
  def initialize(payments_api, mailer, spendings)
    @payments_api = payments_api
    @email = mailer
    @spendings = spendings
  end

  def trigger(user_id, month, year)
    current_month = Time.now.month
    current_year = Time.now.year
    previous_month = current_month == 12 ? 1 :  current_month - 1
    previous_year = current_month == 12 ? current_year - 1 :  current_year
    
    current_month_payments = @payments_api.fetch_payments_by_user_id(user_id,current_month, current_year)
    previous_month_payments = @payments_api.fetch_payments_by_user_id(user_id,previous_month, previous_year)
    has_high_spending = @spendings.has_high_spending?(current_month_payments, previous_month_payments)

    if has_high_spending
      high_spendings = @spendings.get_high_spending_by_category(current_month_payments, previous_month_payments)
      message = @spendings.generate_email(user_id, high_spendings)
      @email.email(user_id, message[:subject], message[:body])
    end
  end
end
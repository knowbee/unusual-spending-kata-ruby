module UnusualSpending
  class HighSpendings
  
    def has_high_spending?(current_month_payments, previous_month_payments)
      totals = get_monthly_payment_totals(current_month_payments, previous_month_payments)
      (totals[:current] / totals[:previous]) > 1.5
    end
  
    def get_high_spending_by_category(current_month_payments, previous_month_payments)
      spendings_by_category = {}
      totals = get_monthly_totals_by_category(current_month_payments, previous_month_payments)
      current_totals = totals[:current]
      previous_totals = totals[:previous]
      current_totals.each do | category, amount |
        if previous_totals.key?(category) && amount.to_i > previous_totals[category].to_i
          spendings_by_category[category.downcase.to_sym] = amount.to_i - previous_totals[category].to_i
        end
      end
      spendings_by_category
    end
  
    def generate_email(user_id, summary)
      if !summary.nil?
        {:subject => get_subject(user_id) , :body => get_body(summary)}
      else
        nil
      end
    end
  
    def get_body(summary)
      message = "We have detected unusually high spending on your card in these categories:\n"
      summary.each do |category, amount|
        message += "* You spent #{amount} on #{category.capitalize}"
        message += "\n"
      end
      message += "Love, \n The Credit Company"
    end
  
    def get_subject(user_id)
      "Hello valued card user ##{user_id}! \n"
    end
    
  
    private
    def get_monthly_payment_totals(current_month_payments, previous_month_payments)
      current_month_total = 0
      previous_month_total = 0
  
      current_month_payments.each do |payment|
        current_month_total += payment[:amount]
      end
      previous_month_payments.each do |payment|
        previous_month_total += payment[:amount]
      end
      {:current=> current_month_total, :previous=> previous_month_total }
    end

    def get_monthly_totals_by_category(current_month_payments, previous_month_payments)
      {:current=> get_spending_by_category(current_month_payments), :previous=> get_spending_by_category(previous_month_payments) }
    end
  
    def get_spending_by_category(monthly_payments)
      category_totals = {}
      monthly_payments.each do |payment|
        if category_totals.key?(payment[:category])
          category_totals[payment[:category]] += payment[:amount]
        else
          category_totals[payment[:category]] = payment[:amount]
        end
      end
      category_totals
    end
end

 
end
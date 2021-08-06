require_relative "wrappers/sendgrid_wrapper"
require_relative "client"

module UnusualSpending
  module Mailer
    class EmailDeliveryError < StandardError
    end
  
    class << self
      def configure
        Mailer::Client.new(email_api_wrapper)
      end
    end
    
  end
end
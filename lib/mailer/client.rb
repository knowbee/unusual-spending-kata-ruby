module UnusualSpending
  
  module Mailer
  
    class Client
      def initialize(email_api_wrapper)
        @email_api_wrapper = email_api_wrapper
      end
  
      def email(user_id, subject, body)
        from = "igwaneza.bruce@gmail.com"
        to = "test@gmail.com"
        response = @email_api_wrapper.send(from, to, subject, body)
  
        raise EmailDeliveryError if response[:status] != 202
        return response
      end
    end
  
  end
end
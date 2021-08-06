require 'sendgrid-ruby'

module UnusualSpending
  module Mailer
    class SendgridService
      include SendGrid
      def send(from, to, subject, body)
        if subject.nil? || body.nil?
          nil
        else 
          from = SendGrid::Email.new(email: from)
          to = SendGrid::Email.new(email: to)
          content = SendGrid::Content.new(type: 'text/plain', value: body)
          mail = SendGrid::Mail.new(from, subject, to, content)
          
          sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
          response = sg.client.mail._('send').post(request_body: mail.to_json)
          {:status=> response.status_code.to_i ,:message => "Email sent to the user"}
        end
      end
    end
  end
end
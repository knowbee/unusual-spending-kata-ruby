require 'sendgrid-ruby'

class Email
  include SendGrid
  def email(user_id, subject, body)
    if subject.nil? || body.nil?
      nil
    else 
      from = SendGrid::Email.new(email: 'igwaneza.bruce@gmail.com')
      to = SendGrid::Email.new(email: 'knowbeeinc@gmail.com')
      content = SendGrid::Content.new(type: 'text/plain', value: body)
      mail = SendGrid::Mail.new(from, subject, to, content)
      
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      {:status=> response.status_code.to_i ,:message => "Email sent to the user with id #{user_id}"}
    end
  end

end
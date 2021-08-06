require "mailer/client"
require "mailer/mailer"

RSpec.describe Mailer::SendgridService do
  let(:sendgrid_service_api){ Mailer::SendgridService.new }
  let(:sendgrid) {instance_double(Mailer::SendgridService)}
  xit "Should fail to send an email with sendgrid service if there is no user_id" do
    client = Mailer::Client.new(sendgrid_service_api)
    expect(client.email(nil, "Subject", "Body")).to raise_error(Mailer::EmailDeliveryError)
  end

  it "Should send an email with sendgrid service" do
    from = "igwaneza.bruce@gmail.com"
    to = "knowbeeinc@gmail.com"
    allow(sendgrid).to receive(:send).with(from, to, "subject", "body").and_return({status: 202, message: "The email is sent to the user"})
    expect(sendgrid.send(from, to, "subject", "body")).to eql({status: 202, message: "The email is sent to the user"})
  end
end
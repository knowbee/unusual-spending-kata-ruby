require "mailer/mailer"
require "UnusualSpending"

RSpec.describe "UnusualSpending::Mailer::Client" do
  let(:sendgrid_service_api){ instance_double(UnusualSpending::Mailer::SendgridService) }
  let(:client) { UnusualSpending::Mailer::Client.new(sendgrid_service_api) }
  it "should send the email to the user" do
    allow(sendgrid_service_api).to receive(:send).and_return({status: 202, message: "The email is sent to the user"})
    response = client.email(1, "subject","body")
    expect(sendgrid_service_api).to have_received(:send)
    expect(response).to eql({status: 202, message: "The email is sent to the user"})
  end

  it "should raise the error if the email is not sent" do
    allow(sendgrid_service_api).to receive(:send).and_return({status: 401, message: "Unauthorized"})
    expect { client.email(1, "subject","body") }.to raise_error(UnusualSpending::Mailer::EmailDeliveryError)
  end
end
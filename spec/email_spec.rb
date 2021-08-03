require "Email"

RSpec.describe "Email" do
  it "should return nil if there is no subject" do
    email = Email.new
    user_id = 1
    expect(email.email(user_id, nil, nil)).to eql(nil) 
  end
  
  it "should send the email to the user" do
    email = Email.new
    user_id = 1
    response = email.email(user_id, "Hello", "Welcome")
    expect(response[:status]).to eql(202) 
    expect(response[:message]).to eql("Email sent to the user with id #{user_id}")
  end
end
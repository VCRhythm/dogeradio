class ContactTristan < ActionMailer::Base
  default from: "support@dogeradio.com"

  def user_email(email, message)
  	@email = email
  	@message = message
  	mail(to: "tristan@dogeradio.com", subject: "Contact from " + @email)
  end
end

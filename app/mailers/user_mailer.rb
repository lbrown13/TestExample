######## CREATED THIS FILE TO MAKE SAME AS DC 6/11 08:50   ##############

class UserMailer < ActionMailer::Base
  default :from => ENV["EMAIL_ADDRESS"]

  def welcome_email(user)
    mail(:to => user.email, :subject => "Invitation Request Received")
    headers['X-MC-GoogleAnalytics'] = ENV["DOMAIN"]
    headers['X-MC-Tags'] = "welcome"
  end
end

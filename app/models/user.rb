class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

# Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
    rolify
# Include default devise modules. Others available are:
# :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, #:confirmable,
           :recoverable, :rememberable, :trackable, :validatable

    # Setup accessible (or protected) attributes for your model
    # attr_accessible :name, :email, :password, :password_confirmation, :remember_me
    def add_user_to_mailchimp
          return if email.include?(ENV['ADMIN_EMAIL'])
          mailchimp = Gibbon.new
          result = mailchimp.list_subscribe({
            :id => ENV['MAILCHIMP_LIST_ID'],
            :email_address => self.email,
            :double_optin => false,
            :update_existing => true,
            :send_welcome => true
            })
          Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
        rescue Gibbon::MailChimpError => e
          Rails.logger.info("MailChimp subscribe failed for #{self.email}: " + e.message)
        end

      def remove_user_from_mailchimp
        mailchimp = Gibbon.new
        result = mailchimp.list_unsubscribe({
          :id => ENV['MAILCHIMP_LIST_ID'],
          :email_address => self.email,
          :delete_member => true,
          :send_goodbye => false,
          :send_notify => true
          })
        Rails.logger.info("Unsubscribed #{self.email} from MailChimp") if result
      rescue Gibbon::MailChimpError => e
        Rails.logger.info("MailChimp unsubscribe failed for #{self.email}: " + e.message)
      end

  end
#   attr_accessible :name, :password
# end

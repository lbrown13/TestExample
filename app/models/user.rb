class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  after_create :add_user_to_mailchimp
  before_destroy :remove_user_from_mailchimp

  # override Devise method
  # no password is required when the account is created; validate password when the user sets one
  validates_confirmation_of :password

  def password_required?
    if !persisted?
      !(password != "")
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

    def confirmation_required?
      false
    end

    def active_for_authentication?
      confirmed? || confirmation_period_valid?
    end

    def send_reset_password_instructions
    if self.confirmed?
      super
    else
      errors.add :base, "You must receive an invitation before you set your password."
    end
  end
  # new function to set the password
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to determine whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method pending_any_confirmation
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

private

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
############ ADDING 6/10 21:29     ###########
class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :role_ids



######### UNCOMMENTED 6/11 08:52 to MAKE SAME AS DC #####


  after_create :add_user_to_mailchimp
  before_destroy :remove_user_from_mailchimp


###########################


  # override Devise method
  # no password is required when the account is created; validate password when the user sets one
  validates_confirmation_of :password

  def password_required?
    if !persisted?
      !(password != "")
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

    def confirmation_required?
      false
    end



######### UNCOMMENTED 6/11 08:52 to MAKE SAME AS DC #####

    # def active_for_authentication?
    #   confirmed? || confirmation_period_valid?
    # end

#########################





    def send_reset_password_instructions
    if self.confirmed?
      super
    else
      errors.add :base, "You must receive an invitation before you set your password."
    end
  end
  # new function to set the password
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to determine whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # new function to provide access to protected method pending_any_confirmation
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end



############# ADDED 6/11 08:54 to make SAME AS DC  ######

private

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
#######################################




end





######################################################

# class User < ActiveRecord::Base
#   # Include default devise modules. Others available are:
#   # :token_authenticatable, :confirmable,
#   # :lockable, :timeoutable and :omniauthable
#   # devise :database_authenticatable, :registerable,
#   #        :recoverable, :rememberable, :trackable, :validatable

# # Setup accessible (or protected) attributes for your model
#   attr_accessible :email, :password, :password_confirmation, :remember_me, :name
#     rolify
# # Include default devise modules. Others available are:
# # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
#     devise :database_authenticatable, :registerable, :confirmable,
#            :recoverable, :rememberable, :trackable, :validatable

#     # Setup accessible (or protected) attributes for your model
#     # attr_accessible :name, :email, :password, :password_confirmation, :remember_me
#     def add_user_to_mailchimp
#           return if email.include?(ENV['ADMIN_EMAIL'])
#           mailchimp = Gibbon.new
#           result = mailchimp.list_subscribe({
#             :id => ENV['MAILCHIMP_LIST_ID'],
#             :email_address => self.email,
#             :double_optin => false,
#             :update_existing => true,
#             :send_welcome => true
#             })
#           Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
#         rescue Gibbon::MailChimpError => e
#           Rails.logger.info("MailChimp subscribe failed for #{self.email}: " + e.message)
#         end

#       def remove_user_from_mailchimp
#         mailchimp = Gibbon.new
#         result = mailchimp.list_unsubscribe({
#           :id => ENV['MAILCHIMP_LIST_ID'],
#           :email_address => self.email,
#           :delete_member => true,
#           :send_goodbye => false,
#           :send_notify => true
#           })
#         Rails.logger.info("Unsubscribed #{self.email} from MailChimp") if result
#       rescue Gibbon::MailChimpError => e
#         Rails.logger.info("MailChimp unsubscribe failed for #{self.email}: " + e.message)
#       end

#   end
# #   attr_accessible :name, :password
# # end

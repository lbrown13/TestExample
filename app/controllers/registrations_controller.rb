class RegistrationsController < Devise::RegistrationsController

  # override #create to respond to Ajax with a partial
  def create
    build_resource
    puts resource.inspect
    resource.password = SecureRandom.uuid
    if resource.save
      puts "resource saved"
      if resource.active_for_authentication?
        puts "active for auth true"
        sign_in(resource_name, resource)
        (render(:partial => 'thankyou', :layout => false) && return)  if request.xhr?
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        puts "activce for auth false"
        expire_session_data_after_sign_in!
        (render(:partial => 'thankyou', :layout => false) && return)  if request.xhr?
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      puts "resource not saved"
      puts resource.errors.inspect
      clean_up_passwords resource
      render :action => :new, :layout => !request.xhr?
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    # the page prelaunch visitors will see after they request an invitation
    # unless Ajax is used to return a partial
    '/thankyou.html'
  end

  def after_sign_up_path_for(resource)
    # the page new users will see after sign up (after launch, when no invitation is needed)

  end

end

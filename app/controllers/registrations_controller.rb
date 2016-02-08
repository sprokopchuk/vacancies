class RegistrationsController < Devise::RegistrationsController

  def after_inactive_sign_up_path_for(resource)
    if resource.role? :employer
      resource.create_company
      company_build_path(:add_country, company_id: resource.company.id)
    else
      super
    end
  end

  protected

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role)
  end

  def account_update_params
    params.require(:user).permit(:current_password, :password, :email, :first_name, :last_name, :role)
  end

end
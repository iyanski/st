class CompaniesController < ApplicationController
  before_action :authenticate_user!, except: [:create, :new, :continue]

  def new
    redirect_to root_url
  end

  def update
    @company = current_company
    @user = current_user
    if @company.update_attributes(company_params)
      if @user.update_attributes(user_params)
        redirect_to admin_url
      else
        flash.now[:notice] = @user.errors.full_messages.first
        render :continue
      end
    else
      flash.now[:notice] = @company.errors.full_messages.first
      render :continue
    end
  end

  def continue
    @company = Company.find_by_domain(request.host_with_port)
    user = @company.users.first
    sign_in :user, user, bypass: true
    session.delete(:user_id)
    render layout: "clean"
  end

  private

    def company_params
      params.require(:company).permit(:name, :address, :address2, :city, :country, :postal_code, :contact_no, :website, :blog)
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name)
    end
end
class CompaniesController < ApplicationController
  before_action :authenticate_user!, except: [:create, :new, :continue]

  def new
    redirect_to root_url
  end

  def create
    errors = []
    
    user = User.where(email: params[:email])
    url = Company.where(subdomain: params[:subdomain])

    if !user.blank?
      errors.push email: "Email is already used"
    end
    if !url.blank?
      errors.push url: "URL is already taken"
    end
    if params[:subdomain].blank?
      errors.push url: "Please provide a URL"
    end

    if !errors.blank?
      render json: errors, status: 401
    else
      user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password])
      company = Company.new(subdomain: params[:subdomain], domain: "#{params[:subdomain]}.#{request.domain}")
      if company.save
        user.company = company
        user.save
        render json: {message: "Registration Successfull", domain: company.domain, subdomain: company.subdomain}
      else
        render json: {error: user.errors.full_messages.first}, status: 401
      end
    end
  end

  def update
    @company = current_company
    @user = current_user
    if @company.update_attributes(company_params)
      if @user.update_attributes(user_params)
        redirect_to root_url
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
    @company = Company.find_by_domain(request.host)
    user = User.find(session[:user_id])
    sign_in :user, current_user, bypass: true
    session.delete(:user_id)
    puts @company.inspect
    render layout: "single"
  end

  private

    def company_params
      params.require(:company).permit(:name, :address, :address2, :city, :country, :postal_code, :contact_no, :website, :blog)
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name)
    end
end
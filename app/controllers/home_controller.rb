class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:admin]
  before_action :authenticate_customer!, only: [:app]
  before_action :authenticate_expert!, only: [:dashboard]
  
  def index
    if current_company
      if current_company.store.nil?
        Store.create
      end
      if !current_company.store.published?
        render layout: 'launch'
      else
        render layout: 'storefront'
      end
    end
  end

  def contact
    render layout: 'storepage'
  end

  def terms
    render layout: 'storepage'
  end

  def about
    render layout: 'storepage'
  end

  def privacy
    # Apartment::Tenant.switch!(current_company.subdomain)
    render layout: 'storepage'
  end

  def faq
    @services = Service.all
    render layout: 'storepage'
  end

  def login
    render layout: "auth"
  end

  def redirector
    puts "#{params[:subdomain]}.#{ENV['app_url']}"
    if !Company.find_by_subdomain(params[:subdomain]).nil?
      redirect_to "http://#{params[:subdomain]}.#{ENV['app_url']}/admin"
    else
      redirect_to "/#{params[:subdomain]}"
    end
  end

  # def redirector
  #   redirect_to root_url(subdomain: params[:subdomain])
  # end

  def app
    gon.company = current_company
    gon.customer = current_customer
    gon.services = Service.where(service_type: 0)
    gon.avatar = current_customer.avatar.try(:url)
    gon.settings = current_customer.customer_setting
    @jobs = current_customer.jobs.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "app"
  end

  def dashboard
    gon.company = current_company
    gon.expert = current_expert
    gon.avatar = current_expert.avatar.try(:url)
    gon.settings = current_expert.expert_setting
    @jobs = Job.pending + current_expert.jobs.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "dashboard"
  end

  def admin
    # begin
    #   Store.last
    # rescue
    #   system("DB_NAME=#{current_company.subdomain} bundle exec rake db:migrate")
    #   puts "DB_NAME=#{current_company.subdomain} bundle exec rake db:migrate"
    # end
    if Store.all.blank?
      store = Store.create(company: current_company)
      gon.store = store
    else
      gon.store = Store.last
    end
    gon.company = current_company
    gon.user = current_user
    gon.avatar = current_user.avatar.try(:url)
    @jobs = Job.all.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "admin"
  end
end

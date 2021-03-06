class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:admin]
  before_action :authenticate_customer!, only: [:app]
  before_action :authenticate_expert!, only: [:dashboard]
  
  def index
    if current_company
      if current_company.store.nil?
        Store.create
      end
      if current_company.store.is_published?
        render layout: 'storefront'
      else
        render layout: 'launch'
      end
    end
  end

  def contact
    if current_company
      render layout: 'storepage'
    end
  end

  def terms
    render layout: 'application'
  end

  def about
    render layout: 'application'
  end

  def privacy
    render layout: 'application'
  end

  def pricing
    render layout: 'single'
  end

  def faq
    @services = Service.all
    if current_company
      render layout: 'storepage'
    end
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

  def app
    gon.aid = current_company.user.id
    gon.company = current_company
    gon.store = current_company.store
    gon.customer = current_customer
    gon.services = Service.all
    gon.avatar = current_customer.avatar.try(:url)
    gon.settings = current_customer.customer_setting
    @jobs = current_customer.jobs.order("updated_at DESC")
    gon.job_id = session[:job_id]
    gon.rabl
    render 'app', layout: "app"
  end

  def dashboard
    gon.aid = current_company.user.id
    gon.company = current_company
    gon.store = current_company.store
    gon.expert = current_expert
    gon.avatar = current_expert.avatar.try(:url)
    gon.settings = current_expert.expert_setting
    @jobs = Job.pending + current_expert.jobs.order("updated_at DESC")
    gon.job_id = session[:job_id]
    gon.rabl
    render 'app', layout: "dashboard"
  end

  def admin
    gon.aid = current_company.user.id
    if Store.all.blank?
      store = Store.create(company: current_company)
      gon.store = store
    else
      gon.store = Store.last
    end
    gon.company = current_company
    gon.store = current_company.store
    gon.user = current_user
    gon.avatar = current_user.avatar.try(:url)
    @jobs = Job.all.order("updated_at DESC")
    gon.job_id = session[:job_id]
    gon.rabl
    render 'app', layout: "admin"
  end
end

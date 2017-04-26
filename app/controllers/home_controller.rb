class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:admin]
  before_action :authenticate_customer!, only: [:app]
  before_action :authenticate_expert!, only: [:dashboard]
  
  def index
  end

  def contact
    render layout: 'storepage'
  end

  def pricing
    render layout: 'application'
  end

  def howitworks
    render layout: 'application'
  end

  def guidelines
    render layout: 'application'
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

  def features
    render layout: 'application'
  end

  def login
    render layout: "auth"
  end

  def redirector
    redirect_to root_url(subdomain: params[:subdomain])
  end

  def app
    Apartment::Tenant.switch!(current_company.subdomain)
    gon.customer = current_customer
    gon.avatar = current_customer.avatar
    # gon.settings = current_customer.expert_setting
    @jobs = Job.pending + current_customer.jobs.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "app"
  end

  def dashboard
    Apartment::Tenant.switch!(current_company.subdomain)
    gon.expert = current_expert
    gon.avatar = current_expert.avatar
    # gon.settings = current_expert.expert_setting
    @jobs = Job.pending + current_expert.jobs.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "dashboard"
  end

  def admin
    Apartment::Tenant.switch!(current_company.subdomain)
    gon.company = current_company
    gon.user = current_user
    gon.avatar = current_user.avatar
    @jobs = Job.all.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "admin"
  end
end

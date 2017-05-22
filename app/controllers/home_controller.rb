class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:admin]
  before_action :authenticate_customer!, only: [:app]
  before_action :authenticate_expert!, only: [:dashboard]
  
  def index
    if Store.last.nil?
      Store.create
      render layout: 'launch'
    else
      unless Store.last.published?
        render layout: 'launch'
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
    Apartment::Tenant.switch!(current_company.subdomain)
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
    redirect_to root_url(subdomain: params[:subdomain])
  end

  def app
    company = current_company
    Apartment::Tenant.switch!(company.subdomain)
    gon.company = company
    gon.customer = current_customer
    gon.services = Service.where(service_type: 0)
    gon.avatar = current_customer.avatar.try(:url)
    gon.settings = current_customer.customer_setting
    @jobs = current_customer.jobs.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "app"
  end

  def dashboard
    company = current_company
    Apartment::Tenant.switch!(company.subdomain)
    gon.company = company
    gon.expert = current_expert
    gon.avatar = current_expert.avatar.try(:url)
    gon.settings = current_expert.expert_setting
    @jobs = Job.pending + current_expert.jobs.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "dashboard"
  end

  def admin
    company = current_company
    Apartment::Tenant.switch!(company.subdomain)
    if company.store.nil?
      Store.create(company: company)
    end
    gon.company = company
    gon.user = current_user
    gon.store = Store.first
    gon.avatar = current_user.avatar.try(:url)
    @jobs = Job.all.order("updated_at DESC")
    gon.rabl
    render 'app', layout: "admin"
  end
end

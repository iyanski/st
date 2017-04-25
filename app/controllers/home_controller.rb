class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:admin]
  
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
    render layout: "app"
  end

  def dashboard
    render layout: "dashboard"
  end

  def admin
    gon.company = current_company
    gon.user = current_user
    gon.avatar = current_user.avatar
    @jobs = Job.all.order("updated_at DESC")
    gon.rabl
    render layout: "admin"
  end
end

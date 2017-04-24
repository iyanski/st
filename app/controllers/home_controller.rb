class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:admin]
  
  def index
    if current_company
      render 'storefront', layout: 'storefront'
    end
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
    render layout: "admin"
  end
end

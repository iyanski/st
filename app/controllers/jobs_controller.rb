class JobsController < ApplicationController
  def show
    session[:job_id] = params[:id]
    if params[:r] = "u"
      redirect_to "/app"
    elsif params[:r] = "e"
      redirect_to "/dashboard"
    else
      redirect_to root_url
    end
  end
end

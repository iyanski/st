class ConversationsController < ApplicationController
  def index
    Apartment::Tenant.switch!(current_company.subdomain)
    @conversations = Job.find(params[:job_id]).conversations
  end
end

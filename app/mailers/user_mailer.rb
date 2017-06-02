class UserMailer < ApplicationMailer
  def new_job(expert, job, url)
    tenant = job.company
    Apartment::Tenant.switch!(tenant.subdomain)
    @url = url
    @job = job
    @recipient = expert
    mail(:to => expert.email, :subject => "A new job has been posted") do |format|
      format.html
    end
  end

  def claim(job, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = job.customer
    @expert = job.expert
    @name = job.customer.name
    mail(:to => @recipient.email, :subject => "#{@expert.name} will be getting in touch with your regarding your job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def unclaim(job, expert, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = job.customer
    @expert = expert
    @name = job.customer.name
    puts "Unclaiming......"
    mail(:to => @recipient.email, :subject => "#{@expert.name} unclaimed the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def estimates(job, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = job.customer
    @name = job.customer.name
    mail(:to => @recipient.email, :subject => "An estimate is available for your job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def approved(job, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = job.expert
    @name = job.expert.name
    mail(:to => @recipient.email, :subject => "Your estimate for job# #{job.code}: #{job.title} has been approved") do |format|
      format.html
    end
  end

  def submit(job, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = job.customer
    @name = job.customer.name
    mail(:to => @recipient.email, :subject => "Please check and approve the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def cancel_estimates(job, expert, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = expert
    @name = expert.name
    mail(:to => @recipient.email, :subject => "The estimate has been cancelled for the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def cancel(job, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = job.expert
    @name = job.expert.name
    mail(:to => @recipient.email, :subject => "The client cancelled the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def decline(job, expert, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = expert
    @name = expert.name
    mail(:to => @recipient.email, :subject => "Updates for the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def completed(job, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @recipient = job.expert
    @name = job.expert.name
    mail(:to => @recipient.email, :subject => "The job# #{job.code}: #{job.title} is now complete") do |format|
      format.html
    end
  end

  def chat(job, message, recipient, sender, url)
    @url = url
    Apartment::Tenant.switch!(job.company.subdomain)
    @job = job
    @message = message
    @recipient = recipient
    @sender = sender.first_name
    @name = recipient.first_name
    mail(:to => @recipient.email, :subject => "#{@name} sent you a message regarding the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def send_expert_registration_information(expert, password, url)
    Apartment::Tenant.switch!(expert.company.subdomain)
    @url = url
    @expert = expert
    @password = password
    @name = expert.name
    @email = expert.email
    mail(:to => @expert.email, :subject => "#{@url} Your #{@expert.company.name} account has been created") do |format|
      format.html
    end
  end
end

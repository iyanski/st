class UserMailer < ApplicationMailer
  def new_job(expert_id)
    @recipient = Expert.find expert_id
    mail(:to => @recipient.email, :subject => "This is just a test email") do |format|
      format.html
    end
  end

  def claim(job)
    @job = job
    @recipient = job.customer
    @expert = job.expert
    @name = job.customer.name
    mail(:to => @recipient.email, :subject => "#{@expert.name} will be getting in touch with your regarding your job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def unclaim(job, expert)
    @job = job
    @recipient = job.customer
    @expert = expert
    @name = job.customer.name
    mail(:to => @recipient.email, :subject => "#{@expert.name} unclaimed the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def estimates(job)
    @job = job
    @recipient = job.customer
    @name = job.customer.name
    mail(:to => @recipient.email, :subject => "An estimate is available for your job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def approved(job)
    @job = job
    @recipient = job.expert
    @name = job.expert.name
    mail(:to => @recipient.email, :subject => "Your estimate for job# #{job.code}: #{job.title} has been approved") do |format|
      format.html
    end
  end

  def submit(job)
    @job = job
    @recipient = job.customer
    @name = job.customer.name
    mail(:to => @recipient.email, :subject => "Please check and approve the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def cancel(job)
    @job = job
    @recipient = job.expert
    @name = job.expert.name
    mail(:to => @recipient.email, :subject => "The client cancelled the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def decline(job, expert)
    @job = job
    @recipient = expert
    @name = expert.name
    mail(:to => @recipient.email, :subject => "Updates for the job# #{job.code}: #{job.title}") do |format|
      format.html
    end
  end

  def completed(job)
    @job = job
    @recipient = job.expert
    @name = job.expert.name
    mail(:to => @recipient.email, :subject => "The job# #{job.code}: #{job.title} is now complete") do |format|
      format.html
    end
  end

  def chat(job, message, recipient, sender)
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

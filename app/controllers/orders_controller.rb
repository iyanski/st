class OrdersController < ApplicationController
  def cancel
    redirect_to app_url
  end

  def notify
    unless params[:custom].nil?
      items = JSON.parse(params[:custom])
      items.each do |item|
        job = Job.find(item["job"].to_i)
        transaction = PaymentTransaction.create_for_ job
        job.complete
      end
    else
      job = Job.find(params[:id])
      transaction = PaymentTransaction.create_for_ job
      job.complete
    end
    render nothing: true
  end

  def new
    unless Cart[session[:cart]].nil?
      job_id = eval(Cart[session[:cart]])[:job]
      details = eval(Cart[session[:cart]])[:details]
      @order = Order.new(:express_token => params[:token])
      @order.ip = request.remote_ip
      @order.customer = current_customer
      @order.job_id = job_id
      if @order.purchase
        if @order.save
          Cart.destroy(session[:cart])
          session.delete(:cart)
          redirect_to app_url, success: "Payment Successful"
        else
          redirect_to root_url, notice: "Something went wront. Don't worry, we're taking care of it"
        end
      else
        redirect_to root_url, notice: "Something went wront. Don't worry, we're taking care of it"
      end
    end
  end
end

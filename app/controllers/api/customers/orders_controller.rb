class Api::Customers::OrdersController < Api::CustomersController
  def express
    items = []
    customs = []
    random = SecureRandom.hex(10)
    session[:cart] = random
    job = Job.find params[:job_id]
    details = Hash({quantity: 1, name: "Job #: #{job.id}", description: job.title, amount: job.price_in_cents})
    items.push details
    customs.push Hash({job: job.id})
    total_amount_in_cents = job.price_in_cents
    Cart[random] = Hash({job: job.id, details: details})

      response = EXPRESS_GATEWAY.setup_purchase(total_amount_in_cents,
        ip: request.remote_ip,
        return_url: new_order_url,
        notify_url: notify_url,
        cancel_return_url: cancel_orders_url,
        currency: "USD",
        allow_guest_checkout: true,
        items: items,
        custom: JSON(customs).to_s
      )
      render json: {proceed_url: EXPRESS_GATEWAY.redirect_url_for(response.token)}
    # else
    #   render json: {message: "Please provide the item amounts"}, status: 401
    # end
    # render json: {proceed_url: EXPRESS_GATEWAY.redirect_url_for(response.token)}
  end
end

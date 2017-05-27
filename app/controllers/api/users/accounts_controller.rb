class Api::Users::AccountsController < Api::UsersController
  def update
    @user = current_user
    account = params[:account]

    unless account.nil?
      customer = User.find_for_authentication(email: current_user.email)
      if customer.valid_password?(account[:current_password])
        customer.password = account[:password]
        customer.save
      end
    end

    unless @user.update_attributes user_params
      render json: {error: @user.errors.full_messages.first}, status: 401
    else
      render json: @user
    end
  end

  def upload
    @user = current_user
    unless params[:file].nil?
      puts params[:file].inspect
      @user.avatar = params[:file]
    end
    unless @user.save
      render json: {error: @user.errors.full_messages.first}, status: 401
    end
  end

  private
    def user_params
      params.require(:account).permit(:first_name, :last_name)
    end
end

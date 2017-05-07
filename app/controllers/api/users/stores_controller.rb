class Api::Users::StoresController < Api::UsersController
  def show
    @store = Store.first
  end
end

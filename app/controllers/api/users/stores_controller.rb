class Api::Users::StoresController < Api::UsersController
  def show
    @store = Store.first
  end

  def update
    @store = Store.first
    unless @store.update_attributes store_params
      render json: {error: @store.errors.full_messages.first}, status: 401
    end
  end

  def upload_cover
    @store = Store.first
    unless params[:file].nil?
      puts params[:file].inspect
      @store.cover = params[:file]
    end
    unless @store.save
      render json: {error: @store.errors.full_messages.first}, status: 401
    end
  end

  def upload_logo
    @store = Store.first
    unless params[:file].nil?
      puts params[:file].inspect
      @store.logo = params[:file]
    end
    unless @store.save
      render json: {error: @store.errors.full_messages.first}, status: 401
    end
  end

  private
    def store_params
      params.require(:store).permit(:title, :tagline, :description, :cover, :logo, :facebook, :twitter, :pinterest, :google)
    end
end
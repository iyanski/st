class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  layout :false
end

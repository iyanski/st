class Api::CustomersController < ApplicationController
  before_action :authenticate_user!
  layout :false
end

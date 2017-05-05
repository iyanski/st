class Api::CustomersController < ApplicationController
  before_action :authenticate_customer!
  layout :false
end

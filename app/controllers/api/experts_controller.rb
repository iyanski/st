class Api::ExpertsController < ApplicationController
  before_action :authenticate_expert!
  layout :false
end

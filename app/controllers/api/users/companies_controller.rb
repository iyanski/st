class Api::Users::CompaniesController < Api::UsersController

  def domain
    @company = current_company
    unless @company.update_attributes(company_params)
      render json: {error: @company.errors.full_messages.first}, status: 401
    end
  end

  private
    def company_params
      params.require(:company).permit(:domain)
    end
end

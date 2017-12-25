module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from(ActionController::UnpermittedParameters) do |pme|
      render json: { error:  { unknown_parameters: pme.params } },
             status: :bad_request
    end
  end
end
class ApiController < ApplicationController
  include ExceptionHandler

  before_action :authenticate_user!

  # before_action :deep_snake_case_params!
  #
  # def default_serializer_options
  #   {root: false}
  # end
  #
  # def deep_snake_case_params!(val = params)
  #   case val
  #     when Array
  #       val.map {|v| deep_snake_case_params! v }
  #     when Hash
  #       val.keys.each do |k, v = val[k]|
  #         val.delete k
  #         val[k.underscore] = deep_snake_case_params!(v)
  #       end
  #       val
  #     else
  #       val
  #   end
  # end

  def default_serializer_options
    {root: false}
  end
end
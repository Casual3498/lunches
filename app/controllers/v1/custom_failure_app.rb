class V1::CustomFailureApp < Devise::FailureApp
include V1::JsonHelper

  def respond
    if request.format == :json
      json_error_response
    else
      super
    end
  end

  def json_error_response
    self.status = :unauthorized
    self.content_type = "application/vnd.api+json"
    self.response_body = errors_json(i18n_message)
  end
end
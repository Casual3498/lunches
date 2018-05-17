module V1::JsonHelper

  #Returns Error hash with received text
  def errors_json(error_text)
      errors = {}
      errors['errors'] = []
      errors['errors'][0] = {}
      errors['errors'][0]['detail'] = error_text
      return errors.to_json
  end

end
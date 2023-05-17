class ErrorVendorSerializer
  
  def initialize(error_object)
    @error_object = error_object
  end

  def not_found_serialized_json
    {
      errors: [
        {
          detail: @error_object
        }
      ]
    }
  end

  def invalid_attr_serialized_json
    {
      errors: [
        {
          detail: "Validation failed: #{@error_object.full_messages.join(", ")}"
        }
      ]
    }
  end
end
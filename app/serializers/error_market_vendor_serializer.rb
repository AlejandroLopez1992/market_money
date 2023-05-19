class ErrorMarketVendorSerializer

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

  def nil_values_serialized_json
    kept_errors = @error_object.full_messages.delete_if { |error| error.include?("must exist")}
    {
            "errors": [
                {
                    "detail": "Validation failed: #{kept_errors.join(", ")}"
                }
            ]
        }
  end

  def already_exists_serialized_json
      {
      "errors": [
          {
              "detail": "Validation failed: #{@error_object[:already_exists][0]}"
          }
      ]
  }
  end
end
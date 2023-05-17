class ErrorMarketSerializer

  def initialize(error_object)
    @error_object = error_object
  end

  def serialized_json
    {
      errors: [
        {
          detail: @error_object,
        }
      ]
    }
  end
end
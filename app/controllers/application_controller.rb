class ApplicationController < ActionController::API

  def market_not_found(id)
    raise ActionController::RoutingError.new({
      "errors": [
          {
              "detail": "Couldn't find Market with 'id'=#{id}"
          }
      ]
  })
  end
end

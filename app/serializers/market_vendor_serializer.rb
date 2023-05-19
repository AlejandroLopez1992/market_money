class MarketVendorSerializer
  include JSONAPI::Serializer

  def success
    {
      "message": "Successfully added vendor to market"
    }
  end
end

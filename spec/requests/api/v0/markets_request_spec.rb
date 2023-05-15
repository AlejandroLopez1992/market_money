require 'rails_helper'

describe "Markets API" do
  it "sends all markets in JSON format" do
    create_list(:market, 8)

    get '/api/v0/markets'

    expect(response).to be_succesful
  end
end
require 'spec_helper'

describe ErrorsController do

  describe "GET 'jsdisabled'" do
    it "returns http success" do
      get 'jsdisabled'
      response.should be_success
    end
  end

end

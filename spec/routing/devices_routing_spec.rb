require "spec_helper"
=begin
describe Admin::DevicesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/devices").should route_to("admin/devices#index", :format => "html")
    end

    it "routes to #new" do
      get("/admin/devices/new").should route_to("admin/devices#new", :format => "html")
    end

    it "routes to #show" do
      get("/admin/devices/1").should route_to("admin/devices#show", :id => "1", :format => "html")
    end

    it "routes to #edit" do
      get("/admin/devices/1/edit").should route_to("admin/devices#edit", :id => "1", :format => "html")
    end

    it "routes to #create" do
      post("/admin/devices").should route_to("admin/devices#create", :format => "html")
    end

    it "routes to #update" do
      put("/admin/devices/1").should route_to("admin/devices#update", :id => "1", :format => "html")
    end

    it "routes to #destroy" do
      delete("/admin/devices/1").should route_to("admin/devices#destroy", :id => "1", :format => "html")
    end

  end
end
=end

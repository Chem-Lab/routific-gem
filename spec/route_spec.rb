require_relative './helper/spec_helper'

describe RoutificApi::Route do
  subject(:route) { Factory::ROUTE }

  Factory::ROUTE_INPUT.each do |key, value|
    it "has #{key}" do
      expect(eval("route.#{key}")).to eq(value)
    end
  end

  describe "parses solution hash into waypoints" do
    subject(:route_with_solution) { Factory::ROUTE_WITH_SOLUTION }

    Factory::ROUTE_INPUT_WITH_SOLUTION.each do |key, value|
      next if key == :solution
      it "has #{key}" do
        expect(eval("route_with_solution.#{key}")).to eq(value)
      end
    end

    it "has vehicle_routes" do
      vehicle_routes = route_with_solution.vehicle_routes
      expect(vehicle_routes).to be_instance_of(Hash)
      expect(vehicle_routes.length).to eq(1)
      expect(vehicle_routes).to have_key("vehicle")
      waypoints = vehicle_routes["vehicle"]
      expect(waypoints).to be_instance_of(Array)
      expect(waypoints.length).to eq(3)
      3.times do |i|
        expect(waypoints[i]).to be_instance_of(RoutificApi::WayPoint)
        Factory::SOLUTION["vehicle"][i].each do |key, value|
          expect(eval("waypoints[i].#{key}")).to eq(value)
        end
      end
    end
  end

  describe "#vehicle_routes" do
    it "is a Hash" do
      expect(route.vehicle_routes).to be_instance_of(Hash)
    end
  end

  describe "#add_way_point" do
    before do
      route.add_way_point(Factory::VEHICLE_NAME, Factory::WAY_POINT)
    end

    it "creates a new key in vehicle_routes" do
      expect(route.vehicle_routes).to include(Factory::VEHICLE_NAME)
    end

    it "stores new waypoint into vehicle_routes" do
      expect(route.vehicle_routes[Factory::VEHICLE_NAME]).to include(Factory::WAY_POINT)
    end
  end
end

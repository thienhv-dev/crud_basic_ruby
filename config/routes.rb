Rails.application.routes.draw do
  Dir.glob(Rails.root.join("modules", "*", "routes", "*.rb")).each do |route_file|
    instance_eval(File.read(route_file), route_file)
  end
end
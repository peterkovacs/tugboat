module Tugboat
  module Middleware
    class ListRegions < Base
      def call(env)
        ocean = env["ocean"]
        regions = ocean.regions.all.sort_by(&:name)

        say "Regions:"
        regions.each do |region|
          say "#{region.name} (slug: #{region.slug})"
        end

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end

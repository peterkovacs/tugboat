module Tugboat
  module Middleware
    class ListSizes < Base
      def call(env)
        ocean = env["ocean"]
        sizes = ocean.sizes.all

        say "Sizes:"
        sizes.each do |size|
          say "#{size.slug} (memory: #{size.memory} vcpus: #{size.vcpus} disk: #{size.disk} hourly: #{size.price_hourly} regions: #{size.regions.join( ' ' )}"
        end

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end

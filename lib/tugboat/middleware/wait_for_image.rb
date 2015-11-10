module Tugboat
  module Middleware
    class WaitForImage < Base
      def call( env )
        ocean = env["ocean"]

        say "Waiting for image to be created.", nil, false

        start_time = Time.now
        image = nil

        loop do
          images = ocean.images.all.reject(&:public)
          image = images.find do |image|
            if env['user_image_name'] == image.name
              true
            elsif env['user_image_id'] == image.id
              true
            else
              false
            end
          end

          break if image

          sleep 5
          say ".", nil, false
        end

        say "#{image.name} (id: #{image.id}, distro: #{image.distribution})"

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end

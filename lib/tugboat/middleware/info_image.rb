module Tugboat
  module Middleware
    class InfoImage < Base
      def call(env)
        ocean = env["ocean"]

        image = ocean.images.find id: env["image_id"]

        say
        say "Name:             #{image.name}"
        say "ID:               #{image.id}"
        say "Distribution:     #{image.distribution}"

        @app.call(env)
      end
    end
  end
end

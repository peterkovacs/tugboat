module Tugboat
  module Middleware
    class DestroyImage < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing destroy image for #{env["image_id"]} #{env["image_name"]}...", nil, false

        begin
          ocean.images.delete id: env["image_id"]
          say "done", :green
          @app.call(env)
        rescue DropletKit::Error => e
          say e.message, :red
          exit 1
        end
      end
    end
  end
end


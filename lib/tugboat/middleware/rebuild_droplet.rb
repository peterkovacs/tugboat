module Tugboat
  module Middleware
    class RebuildDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing rebuild for droplet #{env["droplet_id"]} #{env["droplet_name"]} with image #{env["image_id"]} #{env["image_name"]}...", nil, false
        
        ocean.droplets.rebuild droplet_id: env["droplet_id"],
                               image: env["image_id"]

        say "done", :green

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end

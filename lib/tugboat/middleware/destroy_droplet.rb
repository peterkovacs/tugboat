module Tugboat
  module Middleware
    class DestroyDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing destroy for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

        begin
          ocean.droplets.delete id: env["droplet_id"]
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


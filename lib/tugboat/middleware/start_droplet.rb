module Tugboat
  module Middleware
    class StartDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing start for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
        ocean.droplet_actions.power_on droplet_id: env["droplet_id"]

        say "done", :green

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end

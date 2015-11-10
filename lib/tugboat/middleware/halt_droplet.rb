module Tugboat
  module Middleware
    class HaltDroplet < Base
      def call(env)
        ocean = env["ocean"]

        if env["user_droplet_hard"]
          say "Queuing hard shutdown for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplet_actions.power_off droplet_id: env["droplet_id"]
        else
          say "Queuing shutdown for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplet_actions.shutdown droplet_id: env["droplet_id"]
        end

          say "Halt successful!", :green

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


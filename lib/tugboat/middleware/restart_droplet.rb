module Tugboat
  module Middleware
    class RestartDroplet < Base
      def call(env)
        ocean = env["ocean"]

        req = if env["user_droplet_hard"]
          say "Queuing hard restart for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplet_actions.power_cycle droplet_id: env["droplet_id"]
        else
          say "Queuing restart for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplet_actions.reboot droplet_id: env["droplet_id"]
        end

        say "done", :green

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


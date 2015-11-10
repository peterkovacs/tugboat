module Tugboat
  module Middleware
    class ResizeDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing resize for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

        ocean.droplet_actions.resize id: env["droplet_id"],
                                     size: env["user_droplet_size"]

        say "done", :green

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


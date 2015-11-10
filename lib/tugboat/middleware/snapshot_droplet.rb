module Tugboat
  module Middleware
    class SnapshotDroplet < Base
      def call(env)
        ocean = env["ocean"]
        # Right now, the digital ocean API doesn't return an error
        # when your droplet is not powered off and you try to snapshot.
        # This is a temporary measure to let the user know.
        say "Warning: Droplet must be in a powered off state for snapshot to be successful", :yellow

        say "Queuing snapshot '#{env["user_snapshot_name"]}' for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

        ocean.droplet_actions.snapshot droplet_id: env["droplet_id"],
                                       name: env["user_snapshot_name"]

        say "done", :green

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


module Tugboat
  module Middleware
    class CreateDroplet < Base
      def call(env)
        ocean = env['ocean']

        say "Queueing creation of droplet '#{env["create_droplet_name"]}'...", nil, false

        env["create_droplet_region"] ?
            droplet_region = env["create_droplet_region"] :
            droplet_region = env["config"].default_region

        env["create_droplet_image"] ?
            droplet_image = env["create_droplet_image"] :
            droplet_image = env["config"].default_image

        env["create_droplet_size"] ?
            droplet_size = env["create_droplet_size"] :
            droplet_size = env["config"].default_size

        env["create_droplet_ssh_keys"] ?
            droplet_ssh_key = env["create_droplet_ssh_keys"] :
            droplet_ssh_key = env["config"].default_ssh_key

        env["create_droplet_private_networking"] ?
            droplet_private_networking = env["create_droplet_private_networking"] :
            droplet_private_networking = env["config"].default_private_networking

        env["create_droplet_ip6"] ?
            droplet_ip6 = env["create_droplet_ip6"] :
            droplet_ip6 = env["config"].default_ip6

        env["create_droplet_user_data"] ?
            droplet_user_data = env["create_droplet_user_data"] :
            droplet_user_data = env["config"].default_user_data

        if droplet_user_data
          unless File.file?(droplet_user_data)
            say "Could not find file: #{droplet_user_data}, check your user_data setting"
            exit 1
          else
            user_data_string = File.open(droplet_user_data, 'rb') { |f| f.read }
          end
        end

        env["create_droplet_backups_enabled"] ?
            droplet_backups_enabled = env["create_droplet_backups_enabled"] :
            droplet_backups_enabled = env["config"].default_backups_enabled

        ocean.droplets.create DropletKit::Droplet.new \
          :name               => env["create_droplet_name"],
          :size               => droplet_size,
          :image              => droplet_image,
          :region             => droplet_region,
          :ssh_keys           => droplet_ssh_key,
          :private_networking => droplet_private_networking,
          :backups            => droplet_backups_enabled

        say "done", :green
        @app.call(env)
      rescue DropletKit::Error => e
        say
        say e.message, :red
        exit 1
      end
    end
  end
end

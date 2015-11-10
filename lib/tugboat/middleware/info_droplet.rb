module Tugboat
  module Middleware
    class InfoDroplet < Base
      def call(env)
        ocean = env["ocean"]

        droplet = ocean.droplets.find id: env["droplet_id"]

        if droplet.status == "active"
          status_color = GREEN
        else
          status_color = RED
        end

        attribute = env["user_attribute"]

        attributes_list = [
          ["name",  droplet.name],
          ["id",  droplet.id],
          ["status",  droplet.status],
          ["ip",  droplet.public_ip],
          ["private_ip",  droplet.private_ip],
          ["region",  droplet.region.name],
          ["image",  droplet.image.name],
          ["size",  droplet.size],
          ["backups_active",  (droplet.backups || false)]
        ]
        attributes = Hash[*attributes_list.flatten(1)]

        if attribute
          if attributes.has_key? attribute
            say attributes[attribute]
          else
            say "Invalid attribute \"#{attribute}\"", :red
            say "Provide one of the following:", :red
            attributes_list.keys.each { |a| say "    #{a[0]}", :red }
            exit 1
          end
        else
          if env["user_porcelain"]
            attributes_list.select{ |a| a[1] != nil }.each{ |a| say "#{a[0]} #{a[1]}"}
          else
            say
            say "Name:             #{droplet.name}"
            say "ID:               #{droplet.id}"
            say "Status:           #{status_color}#{droplet.status}#{CLEAR}"
            say "IP:               #{droplet.public_ip}"

            if droplet.private_ip
              say "Private IP:       #{droplet.private_ip}"
    	      end

            say "Region:           #{droplet.region.name} (#{droplet.region.slug})"
            say "Image:            #{droplet.image.name} (#{droplet.image.slug || droplet.image.id})"
            say "Size:             #{droplet.size_slug}"
            say "Backups Active:   #{!droplet.backup_ids.empty?}"
          end
        end

        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        exit 1
      end
    end
  end
end


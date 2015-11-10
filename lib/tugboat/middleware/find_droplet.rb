module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class FindDroplet < Base
      def call(env)
        ocean = env["ocean"]
        user_fuzzy_name = env['user_droplet_fuzzy_name']
        user_droplet_name = env['user_droplet_name']
        user_droplet_id = env['user_droplet_id']
        porcelain = env['user_porcelain']

        # First, if nothing is provided to us, we should quit and
        # let the user know.
        if !user_fuzzy_name && !user_droplet_name && !user_droplet_id

          say "Tugboat attempted to find a droplet with no arguments.", :red
          say "Try running `tugboat #{env['tugboat_action']} dropletname`", :green
          say "For more help run: `tugboat help #{env['tugboat_action']}`", :blue
          exit 1
        end

        if porcelain && (!(user_droplet_name || user_droplet_id) || user_fuzzy_name)
          say "Tugboat expects an exact droplet ID or droplet name for porcelain mode.", :red
          exit 1
        end

        # If you were to `tugboat restart foo -n foo-server-001` then we'd use
        # 'foo-server-001' without looking up the fuzzy name.
        #
        # This is why we check in this order.

        # Easy for us if they provide an id. Just set it to the droplet_id
        if user_droplet_id
          if !porcelain
            say "Droplet id provided. Finding Droplet...", nil, false
          end
          droplet = ocean.droplets.find id: user_droplet_id

          env["droplet_id"] = droplet.id
          env["droplet_name"] = "(#{droplet.name})"
          env["droplet_ip"] = droplet.public_ip
          env["droplet_ip_private"] = droplet.private_ip
          env["droplet_status"] = droplet.status
        end

        # If they provide a name, we need to get the ID for it.
        # This requires a lookup.
        if user_droplet_name && !env["droplet_id"]
          if !porcelain
            say "Droplet name provided. Finding droplet ID...", nil, false
          end

          # Look for the droplet by an exact name match.
          ocean.droplets.all.each do |d|
            if d.name == user_droplet_name
              env["droplet_id"] = d.id
              env["droplet_name"] = "(#{d.name})"
              env["droplet_ip"] = d.public_ip
              env["droplet_ip_private"] = d.private_ip
              env["droplet_status"] = d.status
            end
          end

          # If we coulnd't find it, tell the user and drop out of the
          # sequence.
          if !env["droplet_id"]
            say "error\nUnable to find a droplet named '#{user_droplet_name}'.", :red
            raise "error\nUnable to find a droplet named '#{user_droplet_name}'."
            exit 1
          end
        end

        # We only need to "fuzzy find" a droplet if a fuzzy name is provided,
        # and we don't want to fuzzy search if an id or name is provided
        # with a flag.
        #
        # This requires a lookup.
        if user_fuzzy_name && !env["droplet_id"]
          say "Droplet fuzzy name provided. Finding droplet ID...", nil, false

          found_droplets = []
          choices = []

          ocean.droplets.all.each_with_index do |d, i|
            # Check to see if one of the droplet names have the fuzzy string.
            if d.name.upcase.include? user_fuzzy_name.upcase
              found_droplets << d
            end
          end

          # Check to see if we have more then one droplet, and prompt
          # a user to choose otherwise.
          if found_droplets.length == 1
            env["droplet_id"] = found_droplets.first.id
            env["droplet_name"] = "(#{found_droplets.first.name})"
            env["droplet_ip"] = found_droplets.first.public_ip
            env["droplet_ip_private"] = found_droplets.first.private_ip
            env["droplet_status"] = found_droplets.first.status
          elsif found_droplets.length > 1
            # Did we run the multiple questionairre?
            did_run_multiple = true

            say "Multiple droplets found."
            say
            found_droplets.each_with_index do |d, i|
              say "#{i}) #{d.name} (#{d.id})"
              choices << i.to_s
            end
            say
            choice = ask "Please choose a droplet:", :limited_to => choices
            env["droplet_id"] = found_droplets[choice.to_i].id
            env["droplet_name"] = found_droplets[choice.to_i].name
            env["droplet_ip"] = found_droplets[choice.to_i].public_ip
            env["droplet_ip_private"] = found_droplets[choice.to_i].private_ip
            env["droplet_status"] = found_droplets[choice.to_i].status
          end

          # If we coulnd't find it, tell the user and drop out of the
          # sequence.
          if !env["droplet_id"]
            say "error\nUnable to find a droplet named '#{user_fuzzy_name}'.", :red
            raise "error\nUnable to find a droplet named '#{user_fuzzy_name}'."
            exit 1
          end
        end

        if !did_run_multiple
          if !porcelain
            say "done#{CLEAR}, #{env["droplet_id"]} #{env["droplet_name"]}", :green
          end
        end
        @app.call(env)
      rescue DropletKit::Error => e
        say e.message, :red
        raise
        exit 1
      end
    end
  end
end


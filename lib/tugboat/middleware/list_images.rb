module Tugboat
  module Middleware
    class ListImages < Base
      def call(env)
        ocean = env["ocean"]
        my_images = ocean.images.all.reject(&:public)
        if env["user_show_global_images"]
          global = ocean.images.all.select(&:public)
        else
          say "Listing Your Images"
          say "(Use `tugboat images --global` to show all images)"
        end

        say "My Images:"
        if my_images.count == 0
          say "No images found"
        else
          my_images.each do |image|
            say "#{image.slug} #{image.distribution} #{image.name} (id: #{image.id})"
          end
        end

        if env["user_show_global_images"]
          say
          say "Global Images:"
          global.each do |image|
            say "#{image.slug} #{image.distribution} #{image.name} (id: #{image.id})"
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


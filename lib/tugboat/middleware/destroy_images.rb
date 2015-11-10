module Tugboat
  module Middleware
    class DestroyImages < Base
      def call(env)
        ocean = env['ocean']

        my_images = ocean.images.all.reject(&:public)
        
        my_images.each do |image|
          next if image.id == env['user_image_keep_id'] 
          next if image.name == env['user_image_keep_name'] 

          say "Queuing destroy image for #{image.id} #{image.name}...", nil, true

          unless env["user_confirm_action"]
            response = yes? "Warning! Potentially destructive action. Please confirm [y/n]:"

            if !response
              say "Skipped due to user request.", :red
              # Quit
              next
            end
          end

          begin
            ocean.images.delete id: image.id
            say "done", :green
          rescue DropletKit::Error => e
            say e.message, :red
            exit 1
          end
        end

        @app.call( env )
      end
    end
  end
end

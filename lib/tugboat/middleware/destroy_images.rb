module Tugboat
  module Middleware
    class DestroyImages < Base
      def call(env)
        ocean = env['ocean']

        image_to_keep =  

        my_images = ocean.images.list :filter => "my_images"
        my_images_list = my_images.images
        
        my_images_list.each do |image|
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

          req = ocean.images.delete image.id
          if req.status == "ERROR"
            say "#{req.status}: #{req.error_message}", :red
            exit 1
          end

          say "done", :green
        end

        @app.call( env )
      end
    end
  end
end

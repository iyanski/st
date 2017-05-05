class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Call method
  
  version :thumb, :if => :image? do
    process :resize_to_limit => [200, 200]
  end


  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def image
    @image ||= MiniMagick::Image.open( model.send(mounted_as).path )
  end

  def image_width
    image[:width]
  end

  def image_height
    image[:height]
  end

  def filename
    random_token = Digest::SHA2.hexdigest("#{Time.now.utc}--#{model.job_id.to_s}").first(20)
    ivar = "@#{mounted_as}_secure_token"    
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, random_token)
    "#{model.job_id.to_s.gsub(" ", "-").downcase}-#{token}-#{original_filename}" if original_filename
    if image_width and image_height
      "#{model.job_id.to_s.gsub(" ", "-").downcase}-#{token}-#{image_width}x#{image_height}.jpg" if original_filename
    else
      "#{model.job_id.to_s.gsub(" ", "-").downcase}-#{token}-#{original_filename}" if original_filename
    end
  end

  protected

    def image?(new_file)
      new_file.content_type.start_with? 'image'
    end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end

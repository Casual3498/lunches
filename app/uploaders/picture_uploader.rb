class PictureUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    subfolder = Rails.env.test? ? 'test/' : 
    "uploads/#{subfolder}#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    # For Rails 3.1+ asset pipeline compatibility:
    ActionController::Base.helpers.asset_path("fallback/" + ["noimage.gif"].compact.join('_'))
  
    # "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end


  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [90, 90]
  end

  version :thumb_big do
    process resize_to_limit: [400, 300]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end


end

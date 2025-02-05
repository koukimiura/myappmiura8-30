class ImageUploader < CarrierWave::Uploader::Base
  #画像の変換
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production? || Rails.env.staging?
    storage :fog
  else
    storage :fog
  end
  

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # S3のディレクトリ名
  def store_dir
    original_filename.present?
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}" 
  end
  
  
  
  
# デフォルト画像は1200x5000に収まるようリサイズ
  #process resize_to_limit: [1200, 5000]
  
  # Provide a default URL as a default if there hasn't been a file uploaded:
  #def default_url(*args) if @user.image.nil?
  #For Rails 3.1+ asset pipeline compatibility:
  #ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #"default.png"
  #"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    #end
  #end


  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end


# サムネイル画像
   #Create different versions of your uploaded files:
   #version :thumb do
  
  #resize_to_fitは縦横比を維持したままリサイズするメソッドです.
     #process resize_to_fit: [100, 100]
  # end
    #version :thumb do 
   #process resize_to_fit: [200, 200] 
 #end 

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  
   # 許可する画像の拡張子
  def extension_whitelist
     %w(jpg jpeg gif png)
  end
  
  #画像の向きを整える
  def auto
    manipulate! do|image|
      image.auto_orient
    end
  end
 
  # ここも追加 
  process :auto
  process :resize_to_limit => [850, 600]
  version :thumb do
    process :resize_to_fit => [400, 400]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  
  # 保存するファイルの命名規則
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
     #"something.jpg" if original_filename
  end
   
   
   # 一意となるトークンを作成
  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
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

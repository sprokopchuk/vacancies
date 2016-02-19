
CarrierWave.configure do |config|
  #config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:      ENV['S3_KEY'],
    aws_secret_access_key:  ENV['S3_SECRET'],
    region:                 ENV['S3_REGION'],
    host:                   ENV['S3_ASSET_URL'],
    endpoint:               ENV['S3_ENDPOINT'] # optional, defaults to nil
  }
  config.fog_public     = true
  config.fog_directory    = ENV['S3_BUCKET_NAME']
end



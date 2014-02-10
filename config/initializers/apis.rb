Rails.configuration.apis = YAML.load(ERB.new(File.read("#{Rails.root}/config/api_#{Rails.env}.yml")).result)[Rails.env].symbolize_keys!

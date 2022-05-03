Dir["#{Rails.root}/lib/gem_extensions/**/*.rb"].each { |file| require file }

HashValidator.append_validator(GemExtensions::HashValidator::DateValidator.new)

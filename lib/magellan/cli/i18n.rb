require 'i18n'

I18n.config.backend.load_translations(*Dir.glob(File.expand_path("../locales/*.yml", __FILE__)))

if current_locale = ENV["LANG"]
  I18n.config.backend.available_locales.each do |locale|
    if current_locale =~ /\A#{locale}/
      I18n.config.locale = locale
      break
    end
  end
end

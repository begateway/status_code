# frozen_string_literal: true
require 'i18n'

module StatusCode
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path += Dir[LOCALES_PATH]
  I18n.backend.load_translations

  def self.decode(code, options = {})
    if code
      if options
        receiver = options[:receiver] || :customer
        gw       = options[:gateway].to_s.downcase
        locale   = options[:locale] || :en
        find_message("#{receiver}.#{gw}.#{code}", "#{receiver}.#{code}", locale)
      else
        message("customer.#{code}", :en)
      end
    end
  end

  private_class_method

  def self.find_message(gw_msg_path, general_msg_path, locale)
    message(gw_msg_path, locale) || message(general_msg_path, locale) ||
      message(gw_msg_path, :en) || message(general_msg_path, :en)
  end

  def self.message(path, locale)
    I18n.t(path, locale: locale) if I18n.exists?(path, locale)
  end
end

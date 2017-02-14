# frozen_string_literal: true
require 'i18n'

module StatusCode
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path = Dir[LOCALES_PATH]
  I18n.backend.load_translations

  def self.decode(options)
    find_message(options) if options[:code] && options[:receiver]
  end

  private_class_method

  def self.find_message(options)
    receiver = options[:receiver].to_s.downcase
    code     = options[:code].to_s
    gateway  = options[:gateway].to_s.downcase
    locale   = options[:locale].to_s.downcase.to_sym if options[:locale]
    locale ||= :en
    if I18n.exists?("#{receiver}.#{gateway}.#{code}", locale)
      I18n.t("#{receiver}.#{gateway}.#{code}", locale: locale)
    elsif I18n.exists?("#{receiver}.#{code}", locale)
      I18n.t("#{receiver}.#{code}", locale: locale)
    end
  end
end

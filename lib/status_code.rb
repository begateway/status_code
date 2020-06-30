# frozen_string_literal: true
require 'i18n'

class StatusCode
  APPROVE_CODE = '000'
  DECLINE_CODE = '999'
  LOCALES_PATH = "#{__dir__}/status_code/locales/*.yml".freeze
  I18n.enforce_available_locales = false
  I18n.load_path += Dir[LOCALES_PATH]
  I18n.backend.load_translations

  attr_reader :code, :opts

  def self.decode(code, opts = {})
    opts[:receiver] ||= :customer
    opts[:locale]   ||= :en

    return if code.nil? && opts[:status].nil?
    new(code, opts).send("return_message_#{opts[:receiver]}".to_sym)
  end

  def initialize(code, opts)
    @code = code
    @opts = opts
  end

  def return_message_merchant
    find_message(code) unless code_blank(:merchant)
  end

  def return_message_customer
    if code_blank(:customer) && !opts[:status].nil?
      find_message(opts[:status] ? APPROVE_CODE : DECLINE_CODE)
    else
      find_message(code)
    end
  end

  private

  def message(path)
    I18n.t(path, locale: opts[:locale]) if I18n.exists?(path, opts[:locale])
  end

  def find_message(code)
    message("#{opts[:receiver]}.#{opts[:gateway]}.#{code}") ||
      message("#{opts[:receiver]}.#{code}")
  end

  def code_blank(role)
    opts[:receiver] == role and (code.to_s.empty? || find_message(code).nil?)
  end
end

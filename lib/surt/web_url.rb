# frozen_string_literal: true

require "uri"

module WebUrl
  class InvalidWebUrlError < StandardError; end

  SUPPORTED_SCHEMES = %w[http https].freeze

  extend self

  # Parses +value+ and returns a URI::Generic.
  # Raises InvalidWebUrlError unless it is an absolute http(s) URL with a host.
  def parse(value)
    raise InvalidWebUrlError, "Value can't be blank" if value.nil? || value.strip.empty?

    uri = URI.parse(value)
    scheme = uri.scheme&.downcase

    unless SUPPORTED_SCHEMES.include?(scheme)
      raise InvalidWebUrlError, "Invalid scheme '#{uri.scheme}', must be one of #{SUPPORTED_SCHEMES.join(', ')}"
    end

    raise InvalidWebUrlError, "Host is blank" if uri.host.nil? || uri.host.strip.empty?

    uri
  rescue URI::Error => e
    raise InvalidWebUrlError, e.message
  end

  def valid?(value)
    parse(value)
    true
  rescue InvalidWebUrlError
    false
  end
end

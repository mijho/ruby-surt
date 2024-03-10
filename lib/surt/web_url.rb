module WebUrl
  class InvalidWebUrlError < StandardError; end

  SUPPORTED_SCHEMES = ["http", "https"]

  extend self

  def parse(value)
    if value.nil? || value.strip.empty?
      raise InvalidWebUrlError, "Value can't be blank"
    end

    uri = URI.parse(value)

    unless SUPPORTED_SCHEMES.include?(uri.scheme)
      raise InvalidWebUrlError, "Invalid scheme '#{uri.scheme}', must be one of #{SUPPORTED_SCHEMES.join(', ')}"
    end

    if uri.host.nil? || uri.host.strip.empty?
      raise InvalidWebUrlError, "Host is blank"
    end

    uri
  rescue URI::InvalidURIError => err
    raise InvalidWebUrlError, err.message
  end

  def valid?(value)
    parse(value)
    true
  rescue InvalidWebUrlError
    false
  end
end

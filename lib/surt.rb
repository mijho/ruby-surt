# surt.rb

require 'uri'
require 'surt/web_url'

class Surt
  def self.generate_surt(url)
    # Generates a SURT (Sort-friendly URI Reordering Transform) for the given URL.
    #
    # Parameters:
    # - url: The URL to generate the SURT for.
    #
    # Returns:
    # - The generated SURT string.
    #
    # Raises:
    # - Any exception that occurs during the generation process.
    #
    # Example:
    #   Surt.generate_surt("http://www.example.com:80/path/to/file?query=string#fragment")
    #   # => "com,example)/path/to/file?query=string#fragment"

    begin
      return url unless is_url_valid?(url)

      url = canonicalize_url(url)
      url_lower = url.downcase
      url_obj = URI.parse(url_lower)

      surt = url_obj.host.split(".").reverse.join(",")
      surt += ":#{url_obj.port}" if handle_port?(url, url_obj.port)
      surt += ")"
      surt += url_obj.path
      surt += build_query_params(url_obj.query) if url_obj.query
      surt += "##{url_obj.fragment}" if url_obj.fragment
      return surt
    rescue
      raise
      return url
    end
  end

  private

  def self.is_url_valid?(url)
    WebUrl.valid?(url)
  end

  # TODO: This will need building out. See https://github.com/iipc/urlcanon/tree/master/python
  def self.canonicalize_url(url)
    url = url.gsub(/^(https?:\/\/)www\d*\./, '\1')
    return url
  end

  def self.handle_port?(url, port)
    if url.include?(":80") || url.include?(":443") || (port != 80 && port != 443)
      return true
    else
      return false
    end
  end

  def self.build_query_params(query_params)
    query_string = "?"
    URI.decode_www_form(query_params).sort.each do |key, value|
      query_string += "#{key}=#{value}&"
    end
    query_string = query_string[0..-2]
    return query_string
  end
end

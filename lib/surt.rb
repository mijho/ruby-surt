# frozen_string_literal: true

require "uri"
require "surt/version"
require "surt/web_url"

# Generates SURT (Sort-friendly URI Reordering Transform) keys from URLs.
#
#   Surt.generate_surt("http://www.example.com/path?b=2&a=1")
#   # => "com,example)/path?a=1&b=2"
#
# Input that is not a valid http(s) URL is returned unchanged.
class Surt
  class << self
    # Returns the SURT form of +url+, or +url+ itself if it is not a valid http(s) URL.
    #
    # Example:
    #   Surt.generate_surt("http://www.example.com:80/path/to/file?query=string#fragment")
    #   # => "com,example:80)/path/to/file?query=string#fragment"
    def generate_surt(url)
      return url unless WebUrl.valid?(url)

      normalized = canonicalize(url).downcase
      uri = WebUrl.parse(normalized)

      surt = uri.host.split(".").reverse.join(",")
      surt += ":#{uri.port}" if explicit_port?(normalized)
      surt += ")"
      surt += normalized_path(uri)
      query = sorted_query(uri.query)
      surt += "?#{query}" unless query.empty?
      surt += "##{uri.fragment}" if uri.fragment && !uri.fragment.empty?
      surt
    end

    private

    # Drops a leading "www", "www2", ... from the host.
    # TODO: Full canonicalisation (see https://github.com/iipc/urlcanon/tree/master/python)
    def canonicalize(url)
      url.strip.sub(%r{\A(https?://)www\d*\.}i, '\1')
    end

    # Ports are only kept when written explicitly in the URL, so that
    # "http://example.com/x:80" and "http://user:80@example.com/" are not
    # mistaken for explicit ports.
    def explicit_port?(url)
      authority = url[%r{\A[^:/?#]+://([^/?#]*)}, 1].to_s
      authority.match?(/:\d+\z/)
    end

    def normalized_path(uri)
      uri.path.empty? ? "/" : uri.path
    end

    # Query parameters are kept in their original (percent-encoded) form,
    # empty pairs are dropped, and the rest are sorted by key then value.
    def sorted_query(query)
      return "" if query.nil?

      query.split("&")
           .reject(&:empty?)
           .sort_by { |pair| pair.split("=", 2) }
           .join("&")
    end
  end
end

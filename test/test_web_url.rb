# frozen_string_literal: true

require "minitest/autorun"
require "surt/web_url"

class WebUrlTest < Minitest::Test
  def test_accepts_http_and_https
    assert WebUrl.valid?("http://example.com")
    assert WebUrl.valid?("https://example.com/path?q=1")
  end

  def test_scheme_is_case_insensitive
    assert WebUrl.valid?("HTTPS://example.com")
  end

  def test_rejects_other_schemes
    refute WebUrl.valid?("ftp://example.com")
    refute WebUrl.valid?("mailto:foo@example.com")
  end

  def test_rejects_missing_host
    refute WebUrl.valid?("http:///path")
  end

  def test_rejects_blank_and_nil
    refute WebUrl.valid?(nil)
    refute WebUrl.valid?("  ")
  end

  def test_rejects_unparseable_urls
    refute WebUrl.valid?("http://exa mple.com")
  end

  def test_parse_raises_descriptive_error
    err = assert_raises(WebUrl::InvalidWebUrlError) { WebUrl.parse("ftp://example.com") }
    assert_match(/Invalid scheme 'ftp'/, err.message)
  end

  def test_parse_returns_uri
    assert_equal "example.com", WebUrl.parse("http://example.com").host
  end
end

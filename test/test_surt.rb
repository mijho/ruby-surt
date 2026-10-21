# frozen_string_literal: true

require "minitest/autorun"
require "surt"

class SurtTest < Minitest::Test
  def surt(url) = Surt.generate_surt(url)

  # --- basic hosts, schemes and ports ---

  def test_http_url_returns_valid_surt
    assert_equal "com,example)/", surt("http://example.com/")
  end

  def test_https_url_returns_valid_surt
    assert_equal "com,example)/", surt("https://example.com/")
  end

  def test_http_url_with_www_returns_valid_surt
    assert_equal "com,example)/", surt("http://www.example.com/")
  end

  def test_www_prefix_is_removed_case_insensitively
    assert_equal "com,example)/", surt("HTTP://WWW.Example.COM/")
  end

  def test_numbered_www_prefix_is_removed
    assert_equal "com,example)/", surt("http://www2.example.com/")
  end

  def test_http_url_with_port_returns_valid_surt
    assert_equal "com,example:8080)/", surt("http://example.com:8080/")
  end

  def test_url_with_port_80_returns_valid_surt
    assert_equal "com,example:80)/", surt("http://example.com:80/")
  end

  def test_url_with_port_443_returns_valid_surt
    assert_equal "com,example:443)/", surt("http://example.com:443/")
  end

  def test_ipv6_host_with_port
    assert_equal "[::1]:8080)/", surt("http://[::1]:8080/")
  end

  # --- regressions: port detection must use the authority only ---

  def test_colon_80_in_path_is_not_treated_as_port
    assert_equal "com,example)/x:80y", surt("http://example.com/x:80y")
  end

  def test_colon_443_in_query_is_not_treated_as_port
    assert_equal "com,example)/?a=:443", surt("http://example.com/?a=:443")
  end

  def test_userinfo_containing_80_is_not_treated_as_port
    assert_equal "com,example)/", surt("http://user:80pw@example.com/")
  end

  def test_userinfo_with_explicit_port_keeps_only_real_port
    assert_equal "com,example:8080)/", surt("http://user:80@example.com:8080/")
  end

  # --- paths ---

  def test_empty_path_becomes_slash
    assert_equal "com,example)/", surt("http://example.com")
  end

  def test_url_with_path_returns_valid_surt
    assert_equal "com,example)/path", surt("http://example.com/path")
  end

  # --- queries ---

  def test_url_with_query_returns_valid_surt
    assert_equal "com,example)/path?query=foo", surt("http://example.com/path?query=foo")
  end

  def test_url_with_capitalised_query_returns_valid_surt
    assert_equal "com,example)/path?query=foo", surt("http://example.com/path?QUERY=FOO")
  end

  def test_url_with_multiple_query_params_returns_valid_surt
    assert_equal "com,example)/path?query=foo&query2=bar", surt("http://example.com/path?query=foo&query2=bar")
  end

  def test_url_with_multiple_unsorted_query_params_returns_valid_surt
    assert_equal "com,example)/path?a=bar&b=foo", surt("http://example.com/path?b=foo&a=bar")
  end

  def test_query_params_sorted_by_key_before_value
    assert_equal "com,example)/?a=1&a=2&a-b=3", surt("http://example.com/?a-b=3&a=2&a=1")
  end

  def test_empty_query_pairs_are_dropped
    assert_equal "com,example)/?a=1&b=2", surt("http://example.com/?a=1&&b=2&")
  end

  def test_empty_query_is_dropped
    assert_equal "com,example)/", surt("http://example.com/?")
  end

  def test_query_keeps_plus_and_encoded_ampersand
    assert_equal "com,example)/?a=1+2&b=%26x", surt("http://example.com/?a=1+2&b=%26x")
  end

  def test_query_keeps_bare_key
    assert_equal "com,example)/?flag", surt("http://example.com/?flag")
  end

  # --- fragments ---

  def test_url_with_query_and_fragment_returns_valid_surt
    assert_equal "com,example)/path?query=foo#fragment", surt("http://example.com/path?query=foo#fragment")
  end

  def test_url_with_fragment_returns_valid_surt
    assert_equal "com,example)/path#fragment", surt("http://example.com/path#fragment")
  end

  # --- non-web and invalid input is returned unchanged ---

  def test_mailto_url_returns_valid_url
    assert_equal "mailto:foo@example.com", surt("mailto:foo@example.com")
  end

  def test_dns_url_returns_valid_url
    assert_equal "dns:archive.org", surt("dns:archive.org")
  end

  def test_warcinfo_url_returns_valid_url
    assert_equal "warcinfo:foo.warc.gz", surt("warcinfo:foo.warc.gz")
  end

  def test_url_with_invalid_scheme_returns_original_url
    assert_equal "foo://example.com", surt("foo://example.com")
  end

  def test_url_with_invalid_format_returns_original_url
    assert_equal "example.com", surt("example.com")
  end

  def test_ftp_url_returns_original_url
    assert_equal "ftp://example.com", surt("ftp://example.com")
  end

  def test_invalid_percent_escape_returns_original_url
    assert_equal "http://example.com/?a=%zz", surt("http://example.com/?a=%zz")
  end

  def test_space_in_url_returns_original_url
    assert_equal "http://example.com/a b", surt("http://example.com/a b")
  end

  def test_nil_returns_nil
    assert_nil surt(nil)
  end

  def test_blank_returns_original_value
    assert_equal "   ", surt("   ")
  end
end

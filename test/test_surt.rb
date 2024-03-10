# surt_test.rb

require 'minitest/autorun'
require 'surt'

class SurtTest < Minitest::Test
  def test_http_url_returns_valid_surt
    assert_equal "com,example)/", Surt.generate_surt("http://example.com/")
  end

  def test_https_url_returns_valid_surt
    assert_equal "com,example)/", Surt.generate_surt("https://example.com/")
  end

  def test_http_url_with_www_returns_valid_surt
    assert_equal "com,example)/", Surt.generate_surt("http://www.example.com/")
  end

  def test_http_url_with_port_returns_valid_surt
    assert_equal "com,example:8080)/", Surt.generate_surt("http://example.com:8080/")
  end

  def test_url_with_port_80_returns_valid_surt
    assert_equal "com,example:80)/", Surt.generate_surt("http://example.com:80/")
  end

  def test_url_with_port_443_returns_valid_surt
    assert_equal "com,example:443)/", Surt.generate_surt("http://example.com:443/")
  end

  def test_url_with_path_returns_valid_surt
    assert_equal "com,example)/path", Surt.generate_surt("http://example.com/path")
  end

  def test_url_with_query_returns_valid_surt
    assert_equal "com,example)/path?query=foo", Surt.generate_surt("http://example.com/path?query=foo")
  end

  def test_url_with_capitalised_query_returns_valid_surt
    assert_equal "com,example)/path?query=foo", Surt.generate_surt("http://example.com/path?QUERY=FOO")
  end

  def test_url_with_multiple_query_params_returns_valid_surt
    assert_equal "com,example)/path?query=foo&query2=bar", Surt.generate_surt("http://example.com/path?query=foo&query2=bar")
  end

  def test_url_with_multiple_unsorted_query_params_returns_valid_surt
    assert_equal "com,example)/path?a=bar&b=foo", Surt.generate_surt("http://example.com/path?b=foo&a=bar")
  end

  def test_url_with_query_and_fragment_returns_valid_surt
    assert_equal "com,example)/path?query=foo#fragment", Surt.generate_surt("http://example.com/path?query=foo#fragment")
  end

  def test_url_with_fragment_returns_valid_surt
    assert_equal "com,example)/path#fragment", Surt.generate_surt("http://example.com/path#fragment")
  end

  def test_mailto_url_returns_valid_url
    assert_equal "mailto:foo@example.com", Surt.generate_surt("mailto:foo@example.com")
  end

  def test_dns_url_returns_valid_url
    assert_equal "dns:archive.org", Surt.generate_surt("dns:archive.org")
  end

  def test_warcinfo_url_returns_valid_url
    assert_equal "warcinfo:foo.warc.gz", Surt.generate_surt("warcinfo:foo.warc.gz")
  end

  def test_url_with_invalid_scheme_returns_original_url
    assert_equal "foo://example.com", Surt.generate_surt("foo://example.com")
  end

  def test_url_with_invalid_format_returns_original_url
    assert_equal "example.com", Surt.generate_surt("example.com")
  end

  def test_ftp_url_returns_original_url
    assert_equal "ftp://example.com", Surt.generate_surt("ftp://example.com")
  end
end

# frozen_string_literal: true

require "test_helper"

class Aliyun::TestFacebody < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Aliyun::Facebody::VERSION
  end

  def test_detect_face_ok
    Aliyun::Facebody.configure do |config|
      config.access_key_secret = ENV.fetch("ALIYUN_ACCESS_KEY_SECRET")
      config.access_key_id = ENV.fetch("ALIYUN_ACCESS_KEY_ID")
      config.format = "JSON"
      config.is_vpc = false
    end
    resp = Aliyun::Facebody.detect_face(ENV.fetch("ALIYUN_FACE_TEST_URL"))
    puts resp if resp && !resp["Code"].nil?
    assert resp.nil? || resp["Code"].nil?, "Api Response failed! #{resp["Code"]}"
  end

end

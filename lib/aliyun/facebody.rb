# frozen_string_literal: true

require "aliyun/facebody/version"
require "openssl"
require "base64"
require "faraday"
require "cgi/util"

module Aliyun

  module Facebody

    ENDPOINT = "https://facebody.cn-shanghai.aliyuncs.com"
    ENDPOINT_VPC = "https://facebody-vpc.cn-shanghai.aliyuncs.com"

    class Configuration
      attr_accessor :access_key_secret, :access_key_id, :format, :region_id,
                    :signature_method, :signature_version, :version,
                    :is_vpc

      def initialize
        @access_key_secret = ""
        @access_key_id = ""
        @format = "JSON"
        @region_id = "cn-shanghai"
        @signature_version = "1.0"
        @version = "2019-12-30"
        @signature_method = "HMAC-SHA1"
        @is_vpc = false
      end
    end

    class << self
      attr_writer :configuration
      attr_reader :client

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration) if block_given?
      end

      def detect_face(image_url, **options)
        url = build_url({ Action: "DetectFace", ImageURL: image_url }.merge(options))
        resp = http_client.post url
        resp.body
      end

      private

      def http_client
        @client ||= Faraday.new(headers: { "Content-Type": "application/json" }) do |f|
          f.response :json
        end
      end

      def build_url(user_params)
        params = {
          "SignatureMethod" => configuration.signature_method,
          "SignatureNonce" => seed_signature_nonce,
          "AccessKeyId" => configuration.access_key_id,
          "SignatureVersion" => configuration.signature_version,
          "Timestamp" => seed_timestamp,
          "Format" => configuration.format,
          "RegionId" => configuration.region_id,
          "Version" => configuration.version
        }.merge(user_params)
        coded_params = canonicalized_query_string(params)
        key_secret = configuration.access_key_secret
        "#{configuration.is_vpc ? ENDPOINT_VPC : ENDPOINT}/?Signature=#{sign(key_secret, coded_params)}&#{coded_params}"
      end

      def canonicalized_query_string(params)
        params.sort_by { |key, _| key.to_s }
              .map { |key, value| "#{encode(key)}=#{encode(value)}" }
              .join("&")
      end

      # 生成数字签名
      def sign(key_secret, coded_params)
        key = "#{key_secret}&"
        signature = "POST&#{encode("/")}&#{encode(coded_params)}"
        sign = Base64.encode64(OpenSSL::HMAC.digest("sha1", key, signature).to_s)
        encode(sign.chomp)
      end

      # 对字符串进行 PERCENT 编码
      def encode(input)
        CGI.escape(input.to_s).gsub("+", "%20")
           .gsub("*", "%2A")
           .gsub("~", "%7E")
      end

      # 生成短信时间戳
      def seed_timestamp
        Time.now.utc.strftime("%FT%TZ")
      end

      # 生成短信唯一标识码，采用到微秒的时间戳
      def seed_signature_nonce
        Time.now.utc.strftime("%Y%m%d%H%M%S%L")
      end

    end

  end
end

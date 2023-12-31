# Aliyun::Facebody

阿里云视觉API Ruby实现

## Installation

    bundle install aliyun-facebody

或者在Gemfile中

    gem 'aliyun-facebody'

## Usage

```ruby
Aliyun::Facebody.configure do |config|
  config.access_key_secret = ENV.fetch("ALIYUN_ACCESS_KEY_SECRET")
  config.access_key_id = ENV.fetch("ALIYUN_ACCESS_KEY_ID")
  config.is_vpc = false # 如果同为阿里云服务器可以直接使用vpc节点加快访问速度
end

result = Aliyun::Facebody.detect_face(ENV.fetch("ALIYUN_FACE_TEST_URL"))

```

目前实现的接口有:

1. `DetectFace`  人脸检测与五官定位



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leepood/aliyun-facebody. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/aliyun-facebody/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Aliyun::Facebody project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/aliyun-facebody/blob/master/CODE_OF_CONDUCT.md).

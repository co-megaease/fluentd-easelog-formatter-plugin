require 'helper'
require 'fluent/plugin/formatter_easelog'

class EaseLogFormatterFormatterTest < Test::Unit::TestCase
  # setup do
  #  Fluent::Test.setup
  # end
  def setup
    Fluent::Test.setup
    @formatter = Fluent::Plugin.new_formatter('easelog')
    @time = Fluent::Engine.now
  end

  # test 'failure' do
  # flunk
  # end

  # private

  def create_driver(conf)
    Fluent::Test::Driver::Formatter.new(Fluent::Plugin::EaselogFormatter).configure(conf)
  end

  def configure(conf)
    @formatter = create_driver(conf)
  end

  def test_easelog_format
    configure({})
    record = {
      'date' => '2021-11-20T04:21:25.66Z',
      'logLevel' => 'DEBUG',
      'location' => 'mqttproxy/backend.go:109',
      'contents' => 'produce msg with topic /d2s/weihao/Invert/1/status'
    }
    tag = 'mqtt.proxy'

    formatted = @formatter.instance.format(tag, @time, record)
    expect = 'a=easegress-mqtt,t=,s=,d=2021-11-20T04:21:25.66Z,k=DEBUG,p=mqttproxy/backend.go:109 - produce msg with topic /d2s/weihao/Invert/1/status'
    print formatted + "\n"
    assert_equal(expect, formatted)

    record['contents'] = 'tid=<nil> sid=<nil> BUG: client DemoV1:321:n0mwz4 recv not delete watch'
    formatted = @formatter.instance.format(tag, @time, record)
    expect = 'a=easegress-mqtt,t=,s=,d=2021-11-20T04:21:25.66Z,k=DEBUG,p=mqttproxy/backend.go:109 - BUG: client DemoV1:321:n0mwz4 recv not delete watch'
    print formatted + "\n"
    assert_equal(expect, formatted)
    record['contents'] =
      'tid=73ce0ffc0d8e996e sid=48bf86736951384d eg easegress-0 send topic /s2d/hyrch/Invert/33333333333 to client map[Invert:33333333333:1]'
    formatted = @formatter.instance.format(tag, @time, record)
    expect = 'a=easegress-mqtt,t=73ce0ffc0d8e996e,s=48bf86736951384d,d=2021-11-20T04:21:25.66Z,k=DEBUG,p=mqttproxy/backend.go:109 - eg easegress-0 send topic /s2d/hyrch/Invert/33333333333 to client map[Invert:33333333333:1]'
    print formatted + "\n"
    assert_equal(expect, formatted)
  end
end

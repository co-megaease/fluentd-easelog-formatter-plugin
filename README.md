# fluent-plugin-ease-log-formatter

[Fluentd](https://fluentd.org/) formatter plugin to convert records to easelog formation dedicated to parsing by the EaseStash

## Build image

The plugin is dedicated to packaging as fluentd kubernetes daemonset.  Run `make build` to build image

## Configuration

```
<match test.file>
  @type file
  path /tmp/test.log
  <format>
    @type easelog
    service_name "easegress-mqtt"
  </format>
  time_format "%Y-%m-%d %H:%M:%S"
</match>
```

## Copyright

* Copyright(c) 2021- MegaEase.cn
* License
  * Apache License, Version 2.0

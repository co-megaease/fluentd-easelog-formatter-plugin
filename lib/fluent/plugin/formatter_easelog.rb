#
# Copyright 2021- Kun Zhao
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fluent/plugin/formatter'

module Fluent
  module Plugin
    class EaselogFormatter < Formatter
      Fluent::Plugin.register_formatter('easelog', self)

      config_param :service_name, :string, default: 'easegress-mqtt'

      def initialize
        super
      end

      def configure(conf)
        super
      end

      # ^(?<date>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.[0-9]+Z)\s+(?<logLevel>[Aa]lert|ALERT|[Tt]race|TRACE|[Dd]ebug|DEBUG|[Nn]otice|NOTICE|[Ii]nfo|INFO|[Ww]arn?(?:ing)?|WARN?(?:ING)?|[Ee]rr?(?:or)?|ERR?(?:OR)?|[Cc]rit?(?:ical)?|CRIT?(?:ICAL)?|[Ff]atal|FATAL|[Ss]evere|SEVERE|EMERG(?:ENCY)?|[Ee]merg(?:ency)?)\s+(?<location>[^\s]+)\s+(?<contents>.*)$
      # format := "a=iot-mapping-mgmt,t=794b25e67ebdda86,s=794b25e67ebdda86,d=2021-10-16T07:46:33.160Z,k=INFO ,p=http-nio-18082-exec-2,l=c.z.i.i.m.api.ForwardInfoController - get forwardInfo of 2"
      def format(_tag, _time, record)
        values = []

        contents = if record['contents'].nil?
                     ''
                   else
                     record['contents']
                   end
        details = contents.scan(/tid=([^\s]+)\s+sid=([^\s]+)\s+(.*)/)
        if details.nil? || details.first.nil?
          tid = ''
          sid = ''
          content = contents
        else
          tid = details.first.first.to_s unless details.first.first.nil?
          sid = details.first[1].to_s if details.first.length == 3
          content = details.first.last.to_s unless details.first.last.nil?
        end

        tid = '' if tid == '<nil>'
        sid = '' if sid == '<nil>'

        ### application
        values << 'a=' + service_name
        #### traceId
        values << 't=' + tid + ',s=' + sid
        #### date
        values << 'd=' + record['date'].to_s
        #### level
        values << 'k=' + record['logLevel'].to_s
        #### positon
        # record['location']
        values << 'p=' + record['location'].to_s + ' - ' + content.to_s
        values.join(',')
      end
    end
  end
end

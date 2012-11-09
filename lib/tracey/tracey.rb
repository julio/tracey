module Tracey
  class Base
    def self.timestamp
      Time.now.strftime("%Y-%m-%d %H:%M:%S.%L")
    end

    def self.tracer_uuid
      SecureRandom.base64(8).gsub("/","_").gsub(/=+$/,"")
    end

    def self.tracer_id
      Thread.current[:tree_id] ||= tracer_uuid
    end

    def self.trace_method(class_to_trace, m)
      class_to_trace.class_eval(<<-DEF, __FILE__, __LINE__ + 1
        alias :"old_#{m}" :"#{m}"

        def #{m}(*args)
          Rails.logger.info "[#{timestamp}][Tracey][TREE ID:#{tracer_id}][IN][#{class_to_trace}##{m}]"
          send("old_#{m}", *args)
        ensure
          Rails.logger.info "[#{timestamp}][Tracey][TREE ID:#{tracer_id}][OUT][#{class_to_trace}##{m}]"
        end
      DEF
      )
    end
    
    def self.trace(*classes_to_trace)
      classes_to_trace = [classes_to_trace].flatten

      classes_to_trace.each do |class_to_trace|
        methods_to_trace = class_to_trace.instance_methods(false).reject do |m| 
          m =~ /newrelic/
        end

        methods_to_trace.each do |m|
          trace_method(class_to_trace, m)
        end
      end
    end
  end
end

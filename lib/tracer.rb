# frozen_string_literal: true

require_relative "tracer/version"
require_relative "tracer/call_tracer"

module Tracer
  class Error < StandardError; end

  def self.trace_method(method_name, *args, **kwargs)
    tracer = CallTracer.new(self, method_name, *args, **kwargs)
    tracer.trace
  end

  def self.trace_class_method(klass, method_name, *args, **kwargs)
    tracer = CallTracer.new(klass, method_name, *args, **kwargs)
    tracer.trace
  end
end

require_relative "./class_a.rb"

class CallTracer
  def initialize(root_object, method_name)
    @root_object = root_object
    @method_name = method_name
    @call_stack = []
    @call_paths = []
    @root_file = root_object.class.instance_method(method_name).source_location&.first
  end

  def trace
    tracer = TracePoint.new(:call, :return) do |tp|
      next unless tp.method_id

      if tp.event == :call
        @call_stack.push("#{tp.defined_class}##{tp.method_id}")
      elsif tp.event == :return
        path = @call_stack.join(" -> ")
        @call_paths << path unless @call_paths.include?(path)
        @call_stack.pop
      end
    end

    tracer.enable
    @root_object.send(@method_name)
    tracer.disable

    puts "Call paths from #{@root_object.class}##{@method_name}:"
    @call_paths.each { |path| puts path }
  end
end


CallTracer.new(ClassA.new, :call).trace
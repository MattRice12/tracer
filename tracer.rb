require_relative "./class_a.rb"

class CallTracer
  def initialize(root_object, method_name, *args, **kwargs)
    @root_object = root_object
    @method_name = method_name
    @args = args
    @kwargs = kwargs
    @call_stack = []
    @call_paths = []
  end

  def trace
    tracer = TracePoint.new(:call, :return) do |tp|
      next unless tp.method_id

      if tp.event == :call
        args_str = extract_arguments(tp)
        delimiter = tp.self.is_a?(Module) ? "." : "#"

        method_str = "#{tp.defined_class}#{delimiter}#{tp.method_id}(#{args_str})"
        @call_stack.push(method_str)
      elsif tp.event == :return
        path = @call_stack.join(" -> ")
        @call_paths << path unless @call_paths.include?(path)
        @call_stack.pop
      end
    end

    tracer.enable
    @root_object.public_send(@method_name, *@args, **@kwargs)
    tracer.disable

    puts "Call paths from #{@root_object.class}##{@method_name}:"
    @call_paths.each { |path| puts path }
  end
end

def extract_arguments(tp)
  tp.parameters.map do |type, name|
    begin
      value = tp.binding.local_variable_get(name)
      "#{name}=#{value.class}"
    rescue NameError
      "#{name}=<unknown>"
    end
  end.join(", ")
end

CallTracer.new(ClassA.new(1, 2), :call).trace
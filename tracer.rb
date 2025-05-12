require_relative "./tree_node.rb"
require_relative "./class_a.rb"

class CallTracer
  EXCLUDED_PATHS = %i[
    rbenv
    gems
    internal
    activemodel
    active_record
    active_support
    activesupport
    ddtrace
    timecop
    logger
  ]

  def initialize(root_object, method_name, *args, **kwargs)
    @root_object = root_object
    @method_name = method_name
    @args = args
    @kwargs = kwargs
    @call_stack = []
    @call_paths = []
    @project_root = Dir.pwd
  end

  def trace
    um = @root_object.class.instance_method(@method_name)
    file, line = um.source_location
    root_label = format_method(@root_object.class, @method_name, [], 0, file, instance_method: true)
    root = TreeNode.new(root_label)

    tracer = TracePoint.new(:call, :return) do |tp|
      next unless tp.method_id
      next if EXCLUDED_PATHS.any? { |str| tp.path.include?(str.to_s) }

      if tp.event == :call
        args_str = extract_arguments(tp)
        line = tp.lineno
        instance_method = !tp.self.is_a?(Module)
        label = format_method(tp.defined_class, tp.method_id, args_str, line, tp.path, instance_method: instance_method)
        @call_stack.push(label)
      elsif tp.event == :return
        root.add_path(@call_stack.dup)
        @call_stack.pop
      end
    end

    tracer.enable
    if @root_object.is_a?(Class)
      @root_object.public_send(@method_name, *@args, **@kwargs)
    else
      @root_object.public_send(@method_name, *@args, **@kwargs)
    end
    tracer.disable

    puts "Call Tree:"
    root.print_tree("", true)
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

  def format_method(klass, method_name, args_str, line, path = nil, instance_method:)
    delimiter = instance_method ? "#" : "."
    args_text = args_str.empty? ? '' : "(#{args_str})"
    location = path ? "#{relative_path(path)}:#{line}" : "line #{line}"
    "#{location} `#{delimiter}#{method_name}` #{args_text}"
  end

  def relative_path(path)
    path.start_with?(@project_root) ? path.sub(@project_root + "/", "") : path
  end
end


CallTracer.new(ClassA.new(1, 2), :call).trace

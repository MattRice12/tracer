module Tracer
  class TreeNode
    attr_reader :label, :children

    def initialize(label)
      @label = label
      @children = {}
    end

    def add_path(path)
      return if path.empty?
      head, *tail = path
      child = (@children[head] ||= TreeNode.new(head))
      child.add_path(tail)
    end

    def print_tree(indent = "", is_last = true)
      prefix = indent
      prefix += is_last ? "└── " : "├── "
      puts "#{prefix}#{label}"
      new_indent = indent + (is_last ? "    " : "│   ")
      children.values.each_with_index do |child, i|
        last = i == children.size - 1
        child.print_tree(new_indent, last)
      end
    end
  end
end

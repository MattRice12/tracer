require_relative "./class_b.rb"
require_relative "./class_e.rb"

class ClassA
  def self.call
    new(1, 2).call
  end

  attr_reader :n1, :n2
  
  def initialize(n1, n2)
    @n1 = n1
    @n2 = n2
  end

  def call
    ClassB.call(n1, n2)
    ClassE.call
    sum
  end

  def sum
    n1 + n2
  end
end
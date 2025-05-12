require_relative "./class_d.rb"

class ClassB
  def self.call(n1, n2)
    new.call(n1, n2)
  end
  
  def initialize
  end

  def call(n1, n2)
    ClassD.call
    product(n1, n2)
  end

  def product(n1, n2)
    n1 * n2
  end
end
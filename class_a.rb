require_relative "./class_b.rb"
require_relative "./class_e.rb"

class ClassA
  def self.call
    new.call
  end
  
  def initialize
  end

  def call
    ClassB.call
    ClassE.call
  end
end
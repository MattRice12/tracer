require_relative "./class_d.rb"

class ClassB
  def self.call
    new.call
  end
  
  def initialize
  end

  def call
    ClassD.call
  end
end
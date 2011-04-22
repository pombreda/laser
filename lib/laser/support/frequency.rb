module Laser
  class Frequency
    include Comparable
    attr_reader :name, :val
    def initialize(name, val)
      @name = name
      @val = val
    end
    
    def to_s
      @name.to_s
    end
    alias inspect to_s
    
    def <=>(other)
      @val <=> other.val
    end
    
    NEVER = self.new(:never, 0)
    MAYBE = self.new(:maybe, 1)
    ALWAYS = self.new(:always, 2)
    
    class << self
      undef new
    end
  end
end
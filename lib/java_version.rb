class JavaVersion
  include Comparable

  VersionRegexp = /^JDK(\d+)u(\d+)$/

  class << self
    def valid?(version)
      VersionRegexp === version
    end

    def parse(version)
      raise ArgumentError unless valid?(version) 
      VersionRegexp.match version
      new($1.to_i, $2.to_i)
    end
  end

  def initialize(family_number, update_number)
    @family_number, @update_number = family_number, update_number
  end

  attr_reader :family_number, :update_number

  def <=>(other)
    if self.family_number != other.family_number
      self.family_number <=> other.family_number
    else
      self.update_number <=> other.update_number
    end
  end

  def next_security_update
    self.update_number.next
  end

  def next_critical_patch_update 
    next_multiple_of_5 = next_multiple_of(update_number, 5)
    next_multiple_of_5.even? ? next_multiple_of_5 + 1 : next_multiple_of_5
  end

  def next_limited_update
    next_multiple_of(update_number, 20)
  end

  private

  def next_multiple_of(current, base)
    current + base - (current + base) % base
    ((current+1)..(current+base)).to_a.find{|i| i % base == 0}
  end
end

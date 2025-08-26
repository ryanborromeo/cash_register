class PricingRule
  def self.apply!(breakdown)
    raise NotImplementedError, "Subclasses must implement a .apply! method"
  end
end

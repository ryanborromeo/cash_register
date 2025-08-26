class User
  ROLES = %w[ceo coo vp_engineering].freeze

  attr_reader :role

  def initialize(role)
    raise ArgumentError, "Invalid role: #{role}" unless ROLES.include?(role)
    @role = role
  end

  def display_name
    case role
    when 'ceo'
      'CEO'
    when 'coo'
      'COO'
    when 'vp_engineering'
      'VP of Engineering'
    end
  end

  def pricing_rules
    case role
    when 'ceo'
      [PricingRules::BuyOneGetOneFreeRule]
    when 'coo'
      [PricingRules::BulkDiscountRule]
    when 'vp_engineering'
      [PricingRules::PercentageDiscountRule]
    else
      []
    end
  end

  def self.all_roles
    ROLES.map { |role| new(role) }
  end
end

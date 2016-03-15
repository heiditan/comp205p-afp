class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :nature_of_funding, :other_support_sought, :other_support_offered, :nature_of_financing, :date_founded, :ceo_name, :provider_type, :business_activity

  belongs_to :rolable, :polymorphic => true

  before_save do
    self.nature_of_funding.gsub!(/[\[\]\"]/, "") if attribute_present?("nature_of_funding")
    self.other_support_sought.gsub!(/[\[\]\"]/, "") if attribute_present?("other_support_sought")
    self.nature_of_financing.gsub!(/[\[\]\"]/, "") if attribute_present?("nature_of_financing")
    self.other_support_offered.gsub!(/[\[\]\"]/, "") if attribute_present?("other_support_offered")
  end

    filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :search_query,
      :with_created_at_gte,
      :with_rolable_type,
      :with_provider_type,
      :by_nature_of_funding, 
      :with_date_founded, 
      :with_business_activity,
      :by_other_support_sought,
      :by_nature_of_financing,
      :by_other_support_offered
    ]
  )

  self.per_page = 10

  scope :search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 10
    where(
      terms.map {
        or_clauses = [
         "LOWER(users.email) LIKE ?",
         "LOWER(users.username) LIKE ?",
         "LOWER(users.rolable_type) LIKE ?",
         "LOWER(users.provider_type) LIKE ?",
         "LOWER(users.business_activity) LIKE ?",
         "LOWER(users.ceo_name) LIKE ?",
         "LOWER(users.nature_of_financing) LIKE ?",
         "LOWER(users.nature_of_funding) LIKE ?",
         "LOWER(users.other_support_sought) LIKE ?",
         "LOWER(users.other_support_offered) LIKE ?",
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

    scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("users.created_at #{ direction }")
    when /^email_/
      order("LOWER(users.email) #{ direction }")
    when /^username_/
      order("LOWER(users.username) #{ direction }")
    when /^rolable_type_/
      order("LOWER(users.rolable_type) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :with_created_at_gte, lambda { |ref_date|
    where('users.created_at >= ?', ref_date)
  }

  scope :with_date_founded, lambda { |date_founded|
    where('users.date_founded >= ?', date_founded)
  }

  scope :with_rolable_type, lambda { |rolable_types|
    where(rolable_type:[*rolable_types])
  }

  scope :with_business_activity, lambda { |business_activitys|
    where(business_activity:[*business_activitys])
  }

  scope :with_provider_type, lambda { |provider_types|
    where(provider_type:[*provider_types])
  }

  scope :by_nature_of_funding, ->(nature_of_funding=nil) {
    if nature_of_funding.blank?
      all
    else
      terms = nature_of_funding.split(/\s*,\s*/).map { |t| t.strip }.map { |t| "%#{t}%" }
      where( ( ["users.nature_of_funding like ?"] * terms.count).join(' or '), *terms )
    end
  }

  scope :by_other_support_sought, ->(other_support_sought=nil) {
    if other_support_sought.blank?
      all
    else
      terms = other_support_sought.split(/\s*,\s*/).map { |t| t.strip }.map { |t| "%#{t}%" }
      where( ( ["users.other_support_sought like ?"] * terms.count).join(' or '), *terms )
    end
  }

  scope :by_nature_of_financing, ->(nature_of_financing=nil) {
    if nature_of_financing.blank?
      all
    else
      terms = nature_of_financing.split(/\s*,\s*/).map { |t| t.strip }.map { |t| "%#{t}%" }
      where( ( ["users.nature_of_financing like ?"] * terms.count).join(' or '), *terms )
    end
  }

  scope :by_other_support_offered, ->(other_support_offered=nil) {
    if other_support_offered.blank?
      all
    else
      terms = other_support_offered.split(/\s*,\s*/).map { |t| t.strip }.map { |t| "%#{t}%" }
      where( ( ["users.other_support_offered like ?"] * terms.count).join(' or '), *terms )
    end
  }

  def self.options_for_sorted_by
    [
      ['Email (a-z)', 'email_asc'],
      ['Registration date (newest first)', 'created_at_desc'],
      ['Registration date (oldest first)', 'created_at_asc'],
      ['Name of Organisation (a-z)', 'username_asc'],
      ['Organisation Type (SME or Credit Provider)', 'rolable_type_asc']
    ]
  end

  def self.rolable_type_for_select
    order('LOWER(rolable_type)').map { |e| [e.rolable_type] }.uniq 
  end

  def self.business_activity_for_select
    ['Product', 'Service', 'Others']
  end

  def self.provider_type_for_select
    order('LOWER(provider_type)').select { |e| !e.provider_type.nil? }.map { |e| [e.provider_type] }.uniq
  end

  def self.nature_of_funding_for_select
    ['Loans', 'Equity', 'Options', 'Others']
  end

  def self.other_support_sought_for_select
    ['Financial Management', 'Strategise Expertise', 'Financing Advice', 'Marketing Advice', 'Human Resources Advice', 'Operations Advice', 'Others']
  end

end

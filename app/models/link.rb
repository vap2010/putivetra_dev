class Link < ActiveRecord::Base
  def linkage_enum
    %w( categories events vacancies )
  end
end

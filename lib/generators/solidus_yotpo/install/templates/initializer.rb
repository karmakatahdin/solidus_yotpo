# frozen_string_literal: true

SolidusYotpo.configure do |c|
  c.max_score = 5
  c.display_unapproved_reviews = false
  c.display_reviewer = true
end

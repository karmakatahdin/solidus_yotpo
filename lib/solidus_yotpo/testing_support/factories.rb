# frozen_string_literal: true

FactoryBot.define do
  factory :review, class: SolidusYotpo::Review do
    title { FFaker::Lorem.sentence(6) }
    content { FFaker::Lorem.sentence }
    score { rand(1..5) }
    votes_up { rand(1..100) }
    votes_down { rand(1..100) }

    user
    product
  end
end

FactoryBot.define do
  factory :note do
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    note_date { Faker::Date.backward(days: 30) }
    pet

    trait :recent do
      note_date { Date.today }
    end

    trait :veterinary_visit do
      content { "Veterinary visit: #{Faker::Lorem.sentence}" }
    end
  end
end

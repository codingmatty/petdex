FactoryBot.define do
  factory :pet do
    name { Faker::Creature::Dog.name }
    species { "Dog" }
    breed { Faker::Creature::Dog.breed }
    birth_date { Faker::Date.backward(days: 3650) }
    adoption_date { Faker::Date.backward(days: 365) }
    microchip_number { Faker::Number.number(digits: 15) }
    sex { Faker::Gender.binary_type }
    neutered { Faker::Boolean.boolean }
    color_markings { Faker::Color.color_name }
    user

    trait :cat do
      name { Faker::Creature::Cat.name }
      species { "Cat" }
      breed { Faker::Creature::Cat.breed }
    end

    trait :with_recent_birth_date do
      birth_date { 6.months.ago }
    end
  end
end

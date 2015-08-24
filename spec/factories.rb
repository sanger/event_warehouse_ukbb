FactoryGirl.define do

  sequence :key do |i|
    "example_key_#{i}"
  end

  factory :event_type do
    key
    description 'EventType generated through the factory'
  end

  factory :role_type do
    key
    description 'RoleType generated through the factory'
  end

  factory :subject_type do
    key
    description 'SubjectType generated through the factory'
  end

  factory :event do
    uuid '00000000-0000-0000-0000-000000000000'
    lims_id 'example_lims'
    event_type
    occured_at { 5.seconds.ago }
    user_identifier 'example@example.com'
  end

end

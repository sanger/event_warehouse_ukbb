FactoryGirl.define do

  sequence :key do |i|
    "example_key_#{i}"
  end

  # It might seem like it makes sense just to generate
  # a random uuid. However sequential uuids identified
  # an indexing bug
  sequence :uuid do |i|
    padding = '0' * (12 - i.to_s.length)
    '00000000-0000-0000-0000-'<< padding << i.to_s
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
    uuid
    lims_id 'example_lims'
    event_type
    occured_at { 5.seconds.ago }
    user_identifier 'example@example.com'
  end

  factory :metadatum do
    key 'key'
    value 'value'
    event
  end

end

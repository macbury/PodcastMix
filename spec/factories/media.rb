# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :medium, :class => 'Media' do
    file "MyString"
    duration 1
    mime_type "MyString"
    hash_sum "MyString"
    size 1
    source_url "MyString"
  end
end

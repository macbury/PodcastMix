# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :episode do
    channel_id 1
    title "MyString"
    description "MyText"
    published_at "2013-12-18 12:08:54"
    audio "MyString"
    waveform "MyString"
    duration 1
  end
end

FactoryGirl.define do
  factory :user do
    name      "Janis Hofmann"
    email     "janishofmann@me.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end
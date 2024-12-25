class Notification < ApplicationRecord
  belongs_to :user_trigger, class_name: "User"
  belongs_to :user_target, class_name: "User"
end

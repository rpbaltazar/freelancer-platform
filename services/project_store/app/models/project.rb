class Project < ApplicationRecord
  api_belongs_to :user, class_name: 'Ros::Cognito::User'
end

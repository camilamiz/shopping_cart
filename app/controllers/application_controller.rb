class ApplicationController < ActionController::Base
  # adding this exception for exercise purposes
  protect_from_forgery with: :exception
end

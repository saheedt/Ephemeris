class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  prepend_view_path Rails.root.join("client")
end

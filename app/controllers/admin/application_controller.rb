class Admin::ApplicationController < ApplicationController
  http_basic_authenticate_with :name => Settings.admin.username, :password => Settings.admin.password
  layout 'admin/application'
end

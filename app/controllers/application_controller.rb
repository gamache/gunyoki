class ApplicationController < ActionController::Base
  protect_from_forgery

  def root
    @page_title = 'gunyoki'
  end
end

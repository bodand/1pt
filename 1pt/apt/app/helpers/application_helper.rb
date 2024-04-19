module ApplicationHelper
  def button_classes(hover = 'bg-payne')
    "py-1.5 px-2.5 text-alabaster border-solid bg-charcoal hover:#{hover}"
  end

  def logged_in?
    session[:user_id] != nil
  end
end

module ApplicationHelper
  def button_classes(hover = 'bg-payne')
    "py-1.5 px-2.5 text-alabaster border-solid bg-charcoal hover:#{hover}"
  end

  def logged_in?
    true
  end

  def current_user
    User.new id: 1, name: 'Teszt Béla'
  end
end

class HomeController < ApplicationController
  def index
    render inertia: 'Home/Index', props: {
      users: User.all_roles.map { |user| { role: user.role, display_name: user.display_name } }
    }
  end
end

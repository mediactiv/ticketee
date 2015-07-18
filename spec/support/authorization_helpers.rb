# hlpers for integration tests
module AuthorizationHelpers
  def define_permission!(user, action, thing)
    Permission.create!(user: user, action: action, thing: thing)
  end

  def check_permission_box(permission, object)
    #@note @rails check a checkbox
    check "permissions_#{object.id}_#{permission}"
  end
end

RSpec.configure do |c|
  c.include(AuthorizationHelpers)
end
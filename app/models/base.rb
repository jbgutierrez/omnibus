class Base < ActiveRecord::Base
  self.abstract_class = true
  extend CurrentUserModule
  include CurrentUserModule
end
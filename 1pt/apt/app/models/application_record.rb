class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  RealNameFormat = { with: /\A[\p{L}\d .-]+\z/, message: I18n.t('errors.illegal_char') }
  EmailFormat = { with: /@/, message: I18n.t('errors.invalid_email') }
  UsernameFormat = { with: /\A[\w|\[\]()&+-]+\Z/, message: I18n.t('errors.illegal_char') }
end

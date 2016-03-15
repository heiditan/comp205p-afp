module UsersHelper
  def checked(area)
    @user.nature_of_funding.nil? ? false : @user.nature_of_funding.match(area)
    @user.other_support_sought.nil? ? false : @user.other_support_sought.match(area)
    @user.nature_of_financing.nil? ? false : @user.nature_of_financing.match(area)
    @user.other_support_offered.nil? ? false : @user.other_support_offered.match(area)
  end
end
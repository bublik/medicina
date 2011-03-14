# Controller generated by Typus, use it to extend admin functionality.
class Admin::AttachmentsController < Admin::MasterController

=begin

  ##
  # You can overwrite and extend Admin::MasterController with your methods.
  #
  # Actions have to be defined in <tt>config/typus/application.yml</tt>:
  #
  #   Attachment:
  #     actions:
  #       index: custom_action
  #       edit: custom_action_for_an_item
  #
  # And you have to add permissions on <tt>config/typus/application_roles.yml</tt> 
  # to have access to them.
  #
  #   admin:
  #     Attachment: create, read, update, destroy, custom_action
  #
  #   editor:
  #     Attachment: create, read, update, custom_action_for_an_item
  #

  def index
  end

  def custom_action
  end

  def custom_action_for_an_item
  end

=end

end
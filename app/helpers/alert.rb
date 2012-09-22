# A generic class to encapsulate the simple UIAlertView capability in iOS
class Alert

  attr_reader :dialog, :alert_message, :alert_title, :alert_acknowledge

  def initialize(params = {})
  	@alert_acknowledge = "OK"  #default
  	@alert_message = params[:message] if params[:message]
  	@alert_title = params[:title] if params[:title]
  	@alert_acknowledge =  params[:ok_text] if params[:ok_text]
=begin
    Alert Style                       Text Fields
  UIAlertViewStyleDefault         No user-editable text fields.
  UIAlertViewStyleSecureTextInput   A single text field at index 0.
  UIAlertViewStylePlainTextInput    A single text field at index 0.
  UIAlertViewStyleLoginAndPasswordInput  The login field is at index 0. The password field is at index 1.
=end
  end

  def show
    @dialog ||= UIAlertView.alloc.initWithTitle(@alert_title, message:@alert_message,delegate:nil,cancelButtonTitle:nil,otherButtonTitles:@alert_acknowledge)
    @dialog.UIAlertViewStyle = UIAlertViewStyleDefault
	  @dialog.show
  end

  def message=(msg)
  	@alert_message = msg
  end

  def title=(txt)
  	@alert_title = txt
  end

  def message
  	@alert_message ||= "ALERT"
  end

  def title
  	@alert_title ||= "Important Message"
  end

  def ok_text=(txt)
  	@alert_acknowledge = txt
  end

end
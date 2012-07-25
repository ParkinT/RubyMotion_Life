class UILabel_Adjustable
	# Borrowed and modified the excellent example at http://www.11pixel.com/blog/28/resize-multi-line-text-to-fit-uilabel-on-iphone/
	# adapting it for RubyMotion
	#      This applies only to a multi-line label.  You can use '.adjustsFontSizeToFitWidth = true' for a single-line label

	# usage is:
	#   text = "It's bad luck to be superstitious"
	#   text_label = UILabel.alloc.initWithFrame([[20, 20], [70, 120]])
	#   text_label.numberOfLines = 0 # set 0 for word wrap
  #   text_label.lineBreakMode = UILineBreakModeWordWrap
  #   text_label.setText(text)
	#   adjustableLabel = UILabel_Adjustable.new({:fontName => "Arial", :fontSize => 72, :msg => text, :labelHeight => 120})
	#    ==== or you can be more verbose ====
  #   adjustableLabel = UILabel_Adjustable.new()
  #   adjustableLabel.fontName = "Arial"
  #   adjustableLabel.fontSize = 72
  #   adjustableLabel.msg = text
  #   text_label.setFont(adjustableLabel.bestFit)

  DEBUG_MODE = true
	MIN_FONT_SIZE = 8.0  #change this as desired for your purposes

    PROPERTIES=[
	    :msg,  # the text to display in the UILabel
			:fontName, #define the font you want (using iOS font name)
			:fontSize, #define the largest font size you want
			:labelHeight #this must be set - the height of your UILabel
    ]
    PROPERTIES.each{|prop|
      attr_accessor prop 
    }

=begin
	attr_accessor :msg  # the text to display in the UILabel
	attr_accessor :fontName #define the font you want (using iOS font name)
	attr_accessor :fontSize #define the largest font size you want
	attr_accessor :labelHeight #this must be set - the height of your UILabel
=end

	def initialize(params = {})
=begin
		@labelHeight = params[:labelHeight] if params[:labelHeight]
		@fontName = params[:fontName] if params[:fontName]
		@fontSize = params[:fontSize] if params[:fontSize]
		@msg = params[:msg] if params[:msg]
=end
		params.each{ |key,value|
        if self.class.const_get(:PROPERTIES).member?key.to_sym
          self.send((key.to_s+"=:").to_sym,value)
        end
    }
	end

	def bestFit
		#some defaults
		@labelHeight ||= 180 #if the @labelHeight has not been set, we will assume a default
		@msg ||= "It's bad luck to be superstitious"
		@fontName ||= "Marker Felt"
		@fontSize ||= 28

		font = UIFont.fontWithName(@fontName, size:@fontSize)
		# the loop begins at the largets font size and counts down two point sizes until
		# either it hits a size that will fit or the minimum size we want to allow
		for s in @fontSize.downto(MIN_FONT_SIZE) do
			#set the font size
			font = font.fontWithSize(s)
			NSLog("Trying size: #{s}") if DEBUG_MODE
	        #This step is important: We make a constraint box using only the fixed WIDTH of the UILabel.
	        #The height will be checked later.

			#Next, check how tall the label would be with the desired font.
			labelSize = @msg.sizeWithFont(font, constrainedToSize:[260.0, Float::MAX], lineBreakMode:UILineBreakModeWordWrap)
			#Here is where you use the height requirement!
	   		#Set the value in the if statement to the height of your UILabel
	   		#If the label fits into your required height, it will break the loop and use that font size.
			break if(labelSize.height <= 180.0)
		end
	 	NSLog("Best size is: #{s}") if DEBUG_MODE
		#return the selected font
		font
	end
end

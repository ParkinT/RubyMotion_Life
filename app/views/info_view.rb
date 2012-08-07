class InfoView < UIView

  attr_reader :info_close, :info_box, :instructions
  MARGIN = 10

  def displayText(info)
    text = case info
    when 'info'
      info_text
    when 'instructions'
      instructions_text
    end
    @info_box.setText(text)
#    @info_box.adjustsFontSizeToFitWidth = true   #this only works when the text is set to single-line
    # so I have chosen to do it this way
    adjustableLabel = UILabel_Adjustable.new({:fontName => "Verdana", :fontSize => 75, :labelHeight => frame[1][1], :labelWidth => frame[1][0] - MARGIN, :msg => text})

    @info_box.setFont(adjustableLabel.bestFit)
    @info_box.numberOfLines = 0 #for word wrap
    @info_box.lineBreakMode = UILineBreakModeWordWrap
    @info_box.color = UIColor.whiteColor
    @info_box.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed("infobg.png"))
#    CGContextSetPatternPhase(@info_box, CGSizeMake(-800, 200)) #shift the bgImage
    @instructions.alpha = 0.85
    self.addSubview(@info_box)
    self.addSubview(@info_close)
    self.addSubview(@instructions)
  end

  def initWithFrame(frame)
    if super
      @info_close = UIButton.buttonWithType(UIButtonTypeCustom)
      @info_close.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed("infobg.png"))
      @info_close.frame = [[frame[0][0], 0], [frame[1][0], 32]]
      @info_close.setTitle("x  C L O S E", forState:UIControlStateNormal)
      @info_close.setTitleColor(UIColor.whiteColor, forState:UIControlStateNormal)
      @info_close.setTitleColor(UIColor.yellowColor, forState:UIControlStateSelected)
      @info_close.alpha = 0

      @instructions = UIButton.buttonWithType(UIButtonTypeCustom)
      @instructions.frame = [[frame[0][0] + 10, 0], [25, 25]]
      @instructions.setImage(imgQuestion, forState:UIControlStateNormal)


      frame[0][1] = 32
      @info_box = UILabel.alloc.initWithFrame(frame)

      self.alpha = 0
    end
    return self
  end

  def instructionsTapped(*caller)
    displayText 'instructions'
  end

  def showAnimated
      UIView.animateWithDuration(1.0,
      animations:lambda {
        self.alpha = 100
      },
      completion:lambda { |finished|
        @info_close.alpha = 100
      }
    )
  end

  def hideAnimated
      UIView.animateWithDuration(0.5,
      animations:lambda {
        self.alpha  = 0
      },
      completion:lambda { |finished|
      }
    )
  end

  def viewDidLoad

  end

  def imgQuestion
    UIImage.imageNamed("questionmark")
  end

  def info_text
    <<EOS
    LIFE
 conceived by John Conway
 ========================

 The Rules of life
   Lonely Cells (0 or 1 neighbors) Die    
   Crowded Cells (4+ neighbors) Die    
   Cells with 2 or 3 neighbors Live    
   A new Cell grows where there are    
       EXACTLY 3 neighbors
EOS
  end

  def instructions_text
    <<EOS
    I N S T R U C T I O N S
    -----------------------

    1. Set up a field of cells
    2. Then click `Begin Evolution`
    Your WORLD will evolve (based on The Rules of Life)

    * Shaking the device will set up a random field of cells for you.
    { You can toggle the state of a cell by touchng it }
EOS
  end
end
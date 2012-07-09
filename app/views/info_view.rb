class InfoView < UIView

  attr_reader :info_close

  def initWithFrame(frame)
    if super
      @info_close = UIButton.buttonWithType(UIButtonTypeInfoLight)
      @info_close.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed("infobg.png"))
      @info_close.frame = [[frame[0][0], 0], [frame[1][0], 32]]
      @info_close.setTitle("  C L O S E", forState:UIControlStateNormal)
      @info_close.setTitleColor(UIColor.blackColor, forState:UIControlStateNormal)
      @info_close.setTitleColor(UIColor.yellowColor, forState:UIControlStateSelected)
      @info_close.alpha = 0
      self.addSubview(@info_close)

      frame[0][1] = 32
      info_title = UILabel.alloc.initWithFrame(frame)
      info_title.setText(info_text)
      info_title.adjustsFontSizeToFitWidth = true   #this only works when the text is set to single-line
      # so I have chosen to do it this way
      adjustableLabel = UILabel_Adjustable.new({:fontName => "Verdana", :fontSize => 75, :labelHeight => frame[1][1], :msg => info_text})

      info_title.setFont(adjustableLabel.bestFit)
      info_title.numberOfLines = 0 #for word wrap
      info_title.lineBreakMode = UILineBreakModeWordWrap
      info_title.color = UIColor.whiteColor
      info_title.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed("infobg.png"))
      self.addSubview(info_title)

      self.alpha = 0
    end
    return self
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
    NSLog("InfoView Loaded")
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

end
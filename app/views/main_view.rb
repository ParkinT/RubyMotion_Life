class MainView < UIView

  def initWithFrame(frame)
  end

  def touchesMoved(touches, withEvent:event)
    @touch = touches.anyObject
    self.setNeedsDisplay()
    read_touches
  end

def touchesMoved(touches, withEvent:event)
    @moved = true
    setNeedsDisplay  
  end

  def touchesEnded(touches, withEvent:event)
    @moved = false
    @touches ||= 0
    @touches += 1
    setNeedsDisplay  
  end

  def read_touches
@button = EasyButton.alloc.initWithFrame([[10, 160], [300, 80]])
@button.backgroundColor = '#ff0000'
@button.borderRadius = 14
@button.font = UIFont.boldSystemFontOfSize(26)
@button.textColor = '#fff'
@button.title = "Touch Me"
@button.addTarget(self, action:'butPressed:', forControlEvents:UIControlEventTouchUpInside)

addSubview(@button)
  end

  def butPressed
    a = UIAlertView.new
    a.title = 'Alert'
    a.message = 'Touched'
    a.show
    a.dismiss
  end
end

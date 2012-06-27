class MainViewController < UIViewController

  attr_reader :community
  attr_reader :evolving  #do not respond to user touches
  attr_reader :timer, :first_touch     #internal use
  attr_reader :evolution_iterations, :iterations
  attr_reader :alert

  CELL_X_SIZE = 35
  CELL_Y_SIZE = 35 #these should be configurable and NOT constants

  COLOR_RED = UIColor.colorWithRed(1.0, green: 0.0, blue: 0.0, alpha: 1.0)
  COLOR_GRN = UIColor.colorWithRed(0, green: 1.0, blue: 0.0, alpha: 0.8)

  INIT_CELL = [ "L", "I", "F", "E", " "]

  EVOLVE_TIMER_INTERVAL = 1.0

  #The following lines allow us to modify the application simply by changing the CELL_X_SIZE and CELL_Y_SIZE
  #It will adjust accordingly
  COLS = (UIScreen.mainScreen.applicationFrame.size.width / CELL_X_SIZE).round.to_i
  ROWS = ((UIScreen.mainScreen.applicationFrame.size.height - 15) / CELL_Y_SIZE).round.to_i

  TOTAL_CELLS = COLS * ROWS

  #these are used in surrounding_ids for brevity in the code
  FIRST_COL = CELL_X_SIZE
  LAST_COL = (COLS * FIRST_COL) - CELL_X_SIZE
  FIRST_ROW = CELL_Y_SIZE
  LAST_ROW = (ROWS * FIRST_ROW) - CELL_Y_SIZE

  def viewDidLoad
    build_world

    @evolve_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @evolve_btn.setTitle("Begin Evolution", forState:UIControlStateNormal)
    @evolve_btn.setTitleColor COLOR_GRN, forState:UIControlStateNormal
    @evolve_btn.frame = [[10, UIScreen.mainScreen.applicationFrame.size.height- 15], [(UIScreen.mainScreen.applicationFrame.size.width / 2) -10, 30]]
    @evolve_btn.addTarget(self, action:'startTapped', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@evolve_btn)

    @stop_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @stop_btn.setTitle("Stop Evolution", forState:UIControlStateNormal)
    @stop_btn.setTitleColor COLOR_RED, forState:UIControlStateNormal
    @stop_btn.frame = [[10, UIScreen.mainScreen.applicationFrame.size.height - 15], [(UIScreen.mainScreen.applicationFrame.size.width / 2) -10, 30]]
    @stop_btn.addTarget(self, action:'stopTapped', forControlEvents:UIControlEventTouchUpInside)
    @stop_btn.setHidden true
    self.view.addSubview(@stop_btn)

    frame = [[UIScreen.mainScreen.applicationFrame.size.width * 0.7, UIScreen.mainScreen.applicationFrame.size.height - 38], [50, 30]]
    @iterations = UILabel.alloc.initWithFrame(frame)
    @iterations.adjustsFontSizeToFitWidth = true
    @iterations.textAlignment = UITextAlignmentCenter
    @iterations.backgroundColor = UIColor.whiteColor
    @iterations.text = ""
    self.view.addSubview(@iterations)
    frame = [[UIScreen.mainScreen.applicationFrame.size.width * 0.7, UIScreen.mainScreen.applicationFrame.size.height - 15], [50, 30]]
    @iterations_label = UILabel.alloc.initWithFrame(frame)
    @iterations_label.adjustsFontSizeToFitWidth = true
    @iterations_label.textAlignment = UITextAlignmentCenter
    @iterations_label.backgroundColor = UIColor.whiteColor
    @iterations_label.text = "Evolutions"
    self.view.addSubview(@iterations_label)

    #initialize
    @iterations.setHidden true
    @iterations_label.setHidden true
    @evolution_iterations = 0

    #image for 'living' cell
    @livingImage = UIImage.imageNamed("living.png")
    #image for 'empty' cell
    @emptyImage = UIImage.imageNamed("empty.png")
  end

private

  def startTapped
    @evolving = true
    @evolve_btn.setHidden true
    @stop_btn.setHidden false
    @evolve_btn.setTitle("Continue Evolution", forState:UIControlStateNormal)
     
    start_evolution
  end

  def stopTapped
    @evolving = false
    @evolve_btn.setHidden false
    @stop_btn.setHidden true

    stop_evolution
  end

  def cellTapped(*caller)
    if @evolving
      @alert ||= Alert.new
      @alert.title = "LIFE by Thom Parkin"
      @alert.message = "You cannot alter the cells while they are Evolving.  Stop the Evolution first."
      @alert.show
    else
      update_world unless @first_touch
      @first_touch = true
      toggle_state(caller.__id__)
    end
  end 

  def toggle_state(cell_id)
    idx = find_cell_index cell_id
    cell = @community[idx]
    cell.state = !cell.state
    @community[idx] = cell
    (cell.button).setImage(state_display(cell.state), forState:UIControlStateNormal)  
  end

  def start_evolution
    evolve_one_step  #first evolution must be immediate - before the time event fires

    @iterations.setHidden false
    @iterations_label.setHidden false

    # I have frustrated myself with this block of code.  There must be a more elgant (more Ruby-esque) way to do this!!!
    @timer = NSTimer.scheduledTimerWithTimeInterval EVOLVE_TIMER_INTERVAL,
    target: proc { evolve_one_step },
    selector: :call,
    userInfo: 1, #1 = active, 0 = inactive
    repeats: true
  end

  def evolve_one_step
     @community.each { |cell| 
      survived = living_neighbors(cell)
      cell.evolve(survived)
    }
    @iterations.text = (@evolution_iterations += 1).to_s
    update_world
 end

  def stop_evolution
    @evolving = false
    @evolve_btn.setHidden false
    @stop_btn.setHidden true
    if @timer.userInfo == 1
      @timer.invalidate
    end
  end

  #return a count of the number of neighbors that are living
  def living_neighbors(cell)
    count = 0
    cell.neighborhood.each { |k, v|
      count += 1 if @community[v].state == true
    }
    count
  end

  def build_world
    #iniitialize array
    @community ||= Array.new

    #define cells
    i = 1
    for y in -1..ROWS
      ypos = y * CELL_Y_SIZE
      for x in -1..COLS
        xpos = x * CELL_X_SIZE
        if (ypos) < (UIScreen.mainScreen.applicationFrame.size.height - CELL_Y_SIZE * 1.15) then #we wish to leave a little space for the buttons
          loc = UIButton.buttonWithType(UIButtonTypeCustom)
          loc.backgroundColor = UIColor.lightGrayColor
          loc.setImage(@livingImage, forState: UIControlStateNormal)
          loc.layer.setBorderColor(UIColor.blackColor.CGColor)
          loc.frame = [[xpos, ypos], [CELL_X_SIZE, CELL_Y_SIZE] ]
          cell = Cell.new(loc.__id__, loc) #set the unique identifier and the object
          @community.push cell
          loc.addTarget(self, action:'cellTapped', forControlEvents:UIControlEventTouchUpInside)
          self.view.addSubview(loc)
          i += 1
        end
      end
    end
    @community.each_index { |idx|
      cell = @community[idx]
      loc = cell.button
      ids = surrounding_ids loc.frame.origin.x, loc.frame.origin.y
      cell.add_neighbors( surrounding_ids(loc.frame.origin.x, loc.frame.origin.y) )
    }
    @first_touch = false
  end

  def update_world
    # we need to [re]display the existing cells
    @community.each_index { |idx|
      cell = @community[idx]
      loc = cell.button
      loc.setImage(state_display(cell.state), forState:UIControlStateNormal)
    }
  end

  def find_cell_index(_id)
    @community.each_index { |idx| return idx if (@community[idx].id == _id) }
  end

  def find_cell_index_at(_x, _y)
    ret = nil
    @community.each_index { |idx|
      cell = @community[idx]
      loc = cell.button
      x = loc.frame.origin.x
      y = loc.frame.origin.y
      ret = idx if ((x == _x) && (y == _y))
    }
    ret
  end

  #using our current x and y, calcualte all ids that are adjacent
  def surrounding_ids(_x, _y)
    adj = {} 
    if _x < FIRST_COL || _y < FIRST_ROW || _x > LAST_COL-1 || _y > LAST_ROW-1
      return adj #we are at the edges, the borders
    end
    for x in ((_x.to_i - FIRST_COL)..(_x.to_i + (FIRST_COL))).step FIRST_COL 
      for y in ((_y.to_i - FIRST_ROW)..(_y.to_i + (FIRST_ROW))).step FIRST_ROW 
        idx = find_cell_index_at(x, y)
        if idx != nil
          adj.merge!("#{x}_#{y}" => idx) unless idx == nil
        end
      end
    end
    adj
  end

  def state_display(_state)
    case                      #ruby syntax is so sweet
    when _state then @livingImage #LIVE_CELL
    when !_state then @emptyImage #DEAD_CELL
    end
  end

end

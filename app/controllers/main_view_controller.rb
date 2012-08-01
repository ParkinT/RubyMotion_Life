class MainViewController < UIViewController

  attr_reader :community
  attr_reader :evolving  #do not respond to user touches
  attr_reader :timer, :first_touch, :living_cells  #internal use
  attr_reader :evolution_iterations, :iterations
  attr_reader :alert

  @@last_snapshot = Array.new()
  @@last_cells_count = 0
  @@user_defaults = NSUserDefaults.standardUserDefaults

  RAND_SETUP_SEED = 11 #somewhere between 8 and 13 is perfect

  CELLS_DIR = "cells/"
  CELL_X_SIZE = 35
  CELL_Y_SIZE = 35 #these should be configurable and NOT constants

  COLOR_RED = UIColor.colorWithRed(1.0, green: 0.0, blue: 0.0, alpha: 1.0)
  COLOR_GRN = UIColor.colorWithRed(0, green: 1.0, blue: 0.0, alpha: 0.8)

  CONTROLS_COLOR_BACKGROUND = UIColor.whiteColor
  CONTROLS_BUTTON_COLOR_BACKGROUND = UIColor.lightGrayColor

  INIT_CELL = [ "L", "I", "F", "E", " "]
  INIT_CELL_COLORS = [
    UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:1.0),  #black
    UIColor.colorWithRed(0.5, green:0.5, blue:0.0, alpha:1.0),  #yellow
    UIColor.colorWithRed(0.0, green:1.0, blue:1.0, alpha:1.0),  #blue/green
    UIColor.colorWithRed(1.0, green:0.0, blue:0.0, alpha:1.0),  #red
    UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:1.0)  #black
  ]

  EVOLVE_TIMER_INTERVAL = 1.0

  #The following lines allow us to modify the application simply by changing the CELL_X_SIZE and CELL_Y_SIZE
  #It will adjust accordingly
  COLS = (UIScreen.mainScreen.applicationFrame.size.width / CELL_X_SIZE).round.to_i
  ROWS = ((UIScreen.mainScreen.applicationFrame.size.height - 15) / CELL_Y_SIZE).round.to_i

  TOTAL_CELLS = COLS * ROWS

  #referenced in construct_ui
  ITERATIONS_TOTAL_HEIGHT = 60
  STOP_START_BUTTON_WIDTH = (UIScreen.mainScreen.applicationFrame.size.width / 2) -10
  STOP_START_BUTTON_HEIGHT = 30
  STOP_START_BUTTON_TOP = UIScreen.mainScreen.applicationFrame.size.height - 30
  STOP_START_BUTTON_LEFT = 20
  #===============
  EVOLVE_BUTTON_WIDTH = STOP_START_BUTTON_WIDTH
  EVOLVE_BUTTON_HEIGHT = STOP_START_BUTTON_HEIGHT
  EVOLVE_BUTTON_TOP = STOP_START_BUTTON_TOP
  EVOLVE_BUTTON_LEFT = STOP_START_BUTTON_LEFT
  #===============
  EVOLVE_LABEL_WIDTH = 50
  EVOLVE_LABEL_HEIGHT = ITERATIONS_TOTAL_HEIGHT * 0.45
  EVOLVE_LABEL_TOP = EVOLVE_BUTTON_TOP
  EVOLVE_LABEL_LEFT = UIScreen.mainScreen.applicationFrame.size.width - (EVOLVE_LABEL_WIDTH + 15)
  #===============
  ITERATIONS_WIDTH = EVOLVE_LABEL_WIDTH
  ITERATIONS_HEIGHT = ITERATIONS_TOTAL_HEIGHT * 0.55
  ITERATIONS_TOP = (UIScreen.mainScreen.applicationFrame.size.height) - ITERATIONS_TOTAL_HEIGHT
  ITERATIONS_LEFT = EVOLVE_LABEL_LEFT
  #===============
  CONFIG_WIDTH = 32
  CONFIG_HEIGHT = 32
  CONFIG_TOP = UIScreen.mainScreen.applicationFrame.size.height - CONFIG_HEIGHT
  CONFIG_LEFT = EVOLVE_LABEL_LEFT - CONFIG_WIDTH
  #===============
  INFO_WIDTH = 32
  INFO_HEIGHT = 32
  INFO_TOP = CONFIG_TOP
  INFO_LEFT = 0

  #these are used in surrounding_ids for brevity in the code
  FIRST_COL = CELL_X_SIZE
  LAST_COL = (COLS * FIRST_COL) - CELL_X_SIZE
  FIRST_ROW = CELL_Y_SIZE
  LAST_ROW = (ROWS * FIRST_ROW) - CELL_Y_SIZE

  def viewDidLoad
    build_world
    construct_ui

    #initialize
    @iterations.setHidden true
    @iterations_label.setHidden true
    @evolution_iterations = 0

    #image for 'living' cell
    @livingImages = [
      UIImage.imageNamed(CELLS_DIR + "cell_01"),
      UIImage.imageNamed(CELLS_DIR + "cell_02"),
      UIImage.imageNamed(CELLS_DIR + "cell_03"),
      UIImage.imageNamed(CELLS_DIR + "cell_04"),
      UIImage.imageNamed(CELLS_DIR + "cell_05"),
      UIImage.imageNamed(CELLS_DIR + "cell_06"),
      UIImage.imageNamed(CELLS_DIR + "cell_07"),
      UIImage.imageNamed(CELLS_DIR + "cell_08"),
      UIImage.imageNamed(CELLS_DIR + "cell_09"),
      UIImage.imageNamed(CELLS_DIR + "cell_10")
      ]

    #image for 'empty' cell
    @emptyImage = UIImage.imageNamed("empty")

    #image for configuration action
    @configImage = UIImage.imageNamed("gear")

  end

private

  def construct_ui
    @evolve_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @evolve_btn.setTitle("Begin Evolution", forState:UIControlStateNormal)
    @evolve_btn.setTitleColor COLOR_GRN, forState:UIControlStateNormal
    @evolve_btn.frame = [[EVOLVE_BUTTON_LEFT, EVOLVE_BUTTON_TOP], [EVOLVE_BUTTON_WIDTH, EVOLVE_BUTTON_HEIGHT]]
    @evolve_btn.addTarget(self, action:'startTapped', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@evolve_btn)

    @stop_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @stop_btn.setTitle("Stop Evolution", forState:UIControlStateNormal)
    @stop_btn.setTitleColor COLOR_RED, forState:UIControlStateNormal
    @stop_btn.frame = [[STOP_START_BUTTON_LEFT, STOP_START_BUTTON_TOP], [STOP_START_BUTTON_WIDTH, STOP_START_BUTTON_HEIGHT]]
    @stop_btn.addTarget(self, action:'stopTapped', forControlEvents:UIControlEventTouchUpInside)
    @stop_btn.setHidden true
    self.view.addSubview(@stop_btn)

    frame = [[EVOLVE_LABEL_LEFT, EVOLVE_LABEL_TOP], [EVOLVE_LABEL_WIDTH, EVOLVE_LABEL_HEIGHT]]
    @iterations_label = UILabel.alloc.initWithFrame(frame)
    @iterations_label.adjustsFontSizeToFitWidth = true
    @iterations_label.textAlignment = UITextAlignmentCenter
    @iterations_label.backgroundColor = CONTROLS_COLOR_BACKGROUND
    @iterations_label.text = "Generations"
    self.view.addSubview(@iterations_label)
    frame = [[ITERATIONS_LEFT, ITERATIONS_TOP], [ITERATIONS_WIDTH, ITERATIONS_HEIGHT]]
    @iterations = UILabel.alloc.initWithFrame(frame)
    @iterations.adjustsFontSizeToFitWidth = true
    @iterations.textAlignment = UITextAlignmentCenter
    @iterations.backgroundColor = CONTROLS_COLOR_BACKGROUND
    @iterations.text = ""
    self.view.addSubview(@iterations)
    #================================

    # Information button
    @info_btn = UIButton.buttonWithType(UIButtonTypeInfoDark)
    @info_btn.backgroundColor = CONTROLS_BUTTON_COLOR_BACKGROUND
    @info_btn.frame = [[INFO_LEFT, INFO_TOP], [INFO_WIDTH, INFO_HEIGHT]]
    @info_btn.addTarget(self, action:'infoTapped', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@info_btn)

    # Configuration Screen
    @config_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @config_btn.setImage(@configImage, forState:UIControlStateNormal)
    @config_btn.backgroundColor = CONTROLS_BUTTON_COLOR_BACKGROUND
    @config_btn.frame = [[CONFIG_LEFT, CONFIG_TOP], [CONFIG_WIDTH, CONFIG_HEIGHT]]
    @config_btn.addTarget(self, action:'configTapped', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(@config_btn)

    self.view.setNeedsDisplay
  end

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

  def configTapped(*caller)
    @config_btn.setImage(@configImage, forState:UIControlStateNormal)
  end

  def infoTapped(*caller)
    @infoView ||= InfoView.alloc.initWithFrame([[10, 10], [UIScreen.mainScreen.applicationFrame.size.width - 40, 220]])
    @infoView.displayText('info')
    self.view.insertSubview(@infoView, aboveSubview:self)
    @infoView.showAnimated
    @infoView.info_close.addTarget(self, action:'infoClose', forControlEvents:UIControlEventTouchUpInside)
  end

  def infoClose(*caller)
    @infoView.hideAnimated
  end

  def toggle_state(cell_id)
    idx = find_cell_index cell_id
    cell = @community[idx]
    cell.state = !cell.state
    @community[idx] = cell
    (cell.button).setBackgroundImage(state_display(cell.state), forState:UIControlStateNormal)
  end

  def start_evolution
    save_setup       #if the user likes this setup, he can recall it
    evolve_one_step  #first evolution must be immediate - before the time event fires

    @iterations.setHidden false
    @iterations_label.setHidden false

    @timer ||= NSTimer.scheduledTimerWithTimeInterval EVOLVE_TIMER_INTERVAL,
    target: proc { evolve_one_step },
    selector: :call,
    userInfo: 1, #1 = active, 0 = inactive
    repeats: true
  end

  def evolve_one_step
    @@living_cells_count = 0
    @community.each { |cell| 
      adjacent = living_neighbors(cell)
      if cell.evolve(adjacent) > 0
        @@living_cells_count += 1
      end
    }

    @iterations.text = (@evolution_iterations += 1).to_s
    update_world
    if check_for_stasis?  #are we 'stuck' in a non-changing state?
      @alert ||= Alert.new
      @alert.title = "LIFE by Thom Parkin"
      @alert.message = "We have reached an equilibrium.  No change for future generations."
      @alert.show
      stopTapped
    end
 end

  def stop_evolution
    @evolving = false
    @evolve_btn.setHidden false
    @stop_btn.setHidden true
    return if @timer.nil?
    if @timer.userInfo == 1
      @timer.invalidate
      @timer = nil
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
          loc.backgroundColor = CONTROLS_BUTTON_COLOR_BACKGROUND
          loc.setTitle(INIT_CELL.fetch(i) { |i| INIT_CELL[i % INIT_CELL.size] }, forState:UIControlStateNormal)
          loc.setTitleColor(INIT_CELL_COLORS.fetch(i) { |i| INIT_CELL_COLORS[i % INIT_CELL_COLORS.size] }, forState:UIControlStateNormal)
          loc.setTitleColor(UIColor.redColor, forState:UIControlStateHighlighted)
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
      loc.setImage(state_display(cell.state, cell.age), forState:UIControlStateNormal)
      loc.setTitle("") #remove opening text on the first touch  -  this is not as elegant as I would like
    }
  end

  def find_cell_index(_id)
    @community.each_index { |idx| return idx if (@community[idx].id == _id) }
  end

  def find_cell_index_at(_x, _y)
    @community.each_index { |idx|
      cell = @community[idx]
      loc = cell.button
      x = loc.frame.origin.x
      y = loc.frame.origin.y
      return idx if ((x == _x) && (y == _y))
    }
    return nil
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

  def state_display(_state, _age=-1)  #we can use the 'age' param to determine which image (or image set) is selected
    case                      #ruby syntax is so sweet
    when _state then @livingImages.sample #LIVE_CELL
    when !_state then @emptyImage #DEAD_CELL
    end
  end


 # For `shake` support
  attr_accessor :shaking
  def shaking?
    @shaking
  end

  def viewWillAppear(animated)
    super
    becomeFirstResponder
  end

  def viewDidDisappear(animated)
    super
    resignFirstResponder
  end

  def canBecomeFirstResponder
    true
  end

  def motionEnded(motion, withEvent:event)
    @shaking = motion == UIEventSubtypeMotionShake
    random_setup if !@evolving
  end

  def random_setup
    @community.each { |cell| cell.state = rand(30) < RAND_SETUP_SEED } 
    update_world
  end

  def check_for_stasis?
    if (@@living_cells_count != @@last_cells_count)  #comparison is expensive, so a simple count can help limit the number of times we need to evaluate the entire collection
      @@last_cells_count = @@living_cells_count
      return false
    end
    curr_snapshot = snapshot
    return true if (curr_snapshot == @@last_snapshot)
    #implied else
    @@last_snapshot = curr_snapshot
    return false    
  end

  # return a snapshot of all currently living cells
  def snapshot
    current_snapshot = []
    @community.each_index { |idx|
      cell = @community[idx]
      current_snapshot << cell.id if cell.state
    }
    current_snapshot
  end

  # restore the state to match the passed in snapshot
  def snapshot=(snap)
    @community.each_index { |idx|
      cell = @community[idx]
      cell.state = snap.include? cell.id
    }
    update_world
  end

  def save_setup
    #grab a snapshot and parse it
    curr = snapshot
    @living_cells = []
    curr.each { |cell_id| 
      idx = find_cell_index cell_id
      cell = @community[idx]
      btn = cell.button
      x_loc = btn.frame.origin.x
      y_loc = btn.frame.origin.y
      @living_cells.push "#{x_loc},#{y_loc}"
    }
    saved_state = NSKeyedArchiver.archivedDataWithRootObject(self)
    @@user_defaults["initial_state"] = saved_state

  end

  def load_setup
    saved_state = defaults["initial_state"]
    @living_cells = NSKeyedUnarchiver.unarchiveObjectWithData(saved_state)
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    puts "user_defaults store: #{@living_cells.inspect}"
    encoder.encodeObject(@living_cells, forKey: "state")
  end

  # called when an object is loaded from NSUserDefaults
  # this is an initializer, so should return `self`
  def initWithCoder(decoder)
    @living_cells = decoder.decodeObjectForKey("state")
    puts "user_defaults retrieve: #{@living_cells}"
    self
  end

end

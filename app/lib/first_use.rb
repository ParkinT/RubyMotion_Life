# ============================================================================
#  F I R S T   U S E   ---   The First Gem in your RubyMotion project
#                            by Thom Parkin (c) 2012 Websembly, LLC
#
#   In many iOS applications it is desirable to present the user with an
# introduction or instructional screen ONLY WHEN THE APP IS FIRST RUN.
#  
#   This utility makes it simply to track and determine;
#     - if this is the very first time the application has run on this device
#     - Exactly how many times the application has run
#     - The date of the very first run of the application
#     - The date of the last (most recent) run of the application
#    ---------------------------------------------------------------------
#
#  USAGE:
#     With the single class file (first_use.rb) loaded, you can add a line
#   like this in your main controller - viewDidLoad:
#    usage = FirstUse.new "Cool App 15"
#    if (usage.first_run?)
#      displayInstructions
#    end
#   Although the AppName parameter is optional in the 'new' method it is
#     HIGHLY RECOMMENDED.  This creates a namespace for this application.
#  
#   Public methods you can call are:
#     .first_run? - Returns a boolean (true if this is the first run)
#     .runs       - Number of times this application has run
#     .last_used  - The LAST USED DATE in several formats (as a hash)
#     .reset      - Reset the count of all statistic data
#
# ============================================================================
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#   CHANGELOG:
#       2012-07-29  Initial build completed.  To be pacaked as a Gem
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class FirstUse

  # Returns a boolean
  #    true if this application is virgin (has never run on this device)
  #    false if 
  def first_run?
    @@first_run
  end

  # returns the number of times this application has been run 
  # (since a reset)
  def runs
    total_runs
  end

  #returns bool representing SUCCESS
  def reset
    reset_stats
  end


  # returns the Last Used date (in a hash) as an NSDate and as text in multiple formats
  def last_used
    date_formatter = NSDateFormatter.alloc.init; date_formatter.dateFormat = "yyyy-MM-dd"

    nsdate = date_formatter.dateFromString(date_string)
    {:NSDate => nsdate,
     :text => {
       :intl_dash => date_string,
       :intl_slash => date_string.gsub(/-/, '/'),
       :usa_dash => us_date_string,
       :usa_slash => us_date_string.gsub(/-/, '/'),
       :year => last_used_data[:year],
       :month => last_used_data[:month],
       :day => last_used_data[:day]
     }
   }
  end




private

  attr_reader :first_run, :usage_data, :app_namespace, :app_key

  VERSION = "1.0"
  @@first_run = false

  USAGE_DATA_KEY = "Websembly.FirstUse"
  VERSION_KEY = USAGE_DATA_KEY + ".version"
  KEY_PREFIX = "F1rstUse."
  FIRST_USE = KEY_PREFIX + "INITIALIZED"
  L_YEAR = KEY_PREFIX + "last_year"
  L_MONTH = KEY_PREFIX + "last_month"
  L_DAY = KEY_PREFIX + "last_day"
  I_YEAR = KEY_PREFIX + "initial_year"
  I_MONTH = KEY_PREFIX + "initial_month"
  I_DAY = KEY_PREFIX + "initial_day"
  LIFESPAN = KEY_PREFIX + "lifespan"

  def initialize(appname="")
    @app_namespace = normalize(appname)
    @usage_data = {
                   I_YEAR => 0,
                   I_MONTH => 0,
                   I_DAY => 0,
                   L_YEAR => 0,
                   L_MONTH => 0,
                   L_DAY => 0,
                   LIFESPAN => 0
                 }
    @app_key = "#{USAGE_DATA_KEY}:#{@app_namespace}"

    #get the current UserDefaults : based on this normalized app_namespace
    retrieveDefaults

    #capture this as another access - maybe the first
    @usage_data[LIFESPAN] += 1

    setLast today

    storeChanges
  end

  def total_runs
    @usage_data[LIFESPAN]
  end

  def reset_stats  
    # if we DO NOT reset this one parameter, I can (later) differentiate between total lifetime runs and runs since a reset
#    NSUserDefaults.standardUserDefaults.removeObjectForKey(FIRST_USE)
    NSUserDefaults.standardUserDefaults.removeObjectForKey(@app_key)
    NSUserDefaults.standardUserDefaults.removeObjectForKey(VERSION_KEY)
    NSLog("F1rstUse::All usage statstics have been purged!!!")
    NSUserDefaults.standardUserDefaults.synchronize #write cache
  end

  def retrieveDefaults
    prefs = NSUserDefaults.standardUserDefaults.dictionaryRepresentation
    if prefs.has_key? @app_key
      @usage_data = NSUserDefaults.standardUserDefaults.objectForKey(@app_key)
      version_check NSUserDefaults.standardUserDefaults.objectForKey(VERSION_KEY)

      #just in case things got out of synch
      @@first_run = true if (@usage_data[I_YEAR] == 0 || @usage_data[I_MONTH] == 0 || @usage_data[I_DAY] == 0)
    else
      @@first_run = true
    end
    setInitial today if @@first_run
  end

  #returns a boolean indicating success
  def storeChanges
    # this will be only written once and never updated
    NSUserDefaults.standardUserDefaults.setObject("#{today['y']}#{today['m']}#{today['d']}", forKey:FIRST_USE) unless (NSUserDefaults.standardUserDefaults.dictionaryRepresentation).has_key?(FIRST_USE)

    NSUserDefaults.standardUserDefaults.setObject(VERSION, forKey:VERSION_KEY)
    NSUserDefaults.standardUserDefaults.setObject(@usage_data, forKey:@app_key)
    NSUserDefaults.standardUserDefaults.synchronize  #write cache
  end

  def setInitial(dateHash)
    @usage_data[I_YEAR] = dateHash["y"]
    @usage_data[I_MONTH] = dateHash["m"]
    @usage_data[I_DAY] = dateHash["d"]
  end

  def setLast(dateHash)
    @usage_data[L_YEAR] = dateHash["y"]
    @usage_data[L_MONTH] = dateHash["m"]
    @usage_data[L_DAY] = dateHash["d"]
  end

  def today
    dateToday = NSDate.date
    dateFormat = NSDateFormatter.alloc.init
    dateFormat.setDateFormat("yyyy")
    year = dateFormat.stringFromDate(dateToday)
    dateFormat.setDateFormat("dd")
    day = dateFormat.stringFromDate(dateToday)
    dateFormat.setDateFormat("MM")
    month = dateFormat.stringFromDate(dateToday)
    {"y" => year, "m" => month, "d" => day}
  end

  # for last used date output
  def date_string
    "#{@usage_data[L_YEAR]}-#{@usage_data[L_MONTH]}-#{@usage_data[L_DAY]}"
  end
  def us_date_string
    "#{@usage_data[L_MONTH]}-#{@usage_data[L_DAY]}-#{@usage_data[L_YEAR]}"
  end
  def last_used_data
    {
       :year => @usage_data[L_YEAR],
       :month => @usage_data[L_MONTH],
       :day => @usage_data[L_DAY]
     }
  end

  def version_check(ver)
    #stub for future development
  end

  def normalize(name)
    return "unnamed" if name == ""
    name.gsub(/[^a-zA-Z0-9.:-]/,'_').downcase!
  end

end
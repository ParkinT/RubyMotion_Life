class Cell

  attr_accessor :id
  attr_accessor :button #object
  attr_reader :current_state, #what we show to the world as state
              :age,
              :neighborhood,
              :state_changed

  def initialize(_id, _btn)
    @id = _id
    @button = _btn
    @neighbors = Array.new  #we need to initialize
    @state_changed = true
    @lifespan = 0
  end

  def state=(s)
    if !!s == s #is a boolean 
      @current_state = s
    else
      @current_state = false
    end
  end

  def button
    return @button
  end

  def changed?
    @state_changed
  end

  def age
    @lifespan.to_i
  end

=begin
          THE RULES
         For a space that is 'populated':
        * Each cell with one or no neighbors dies, as if by loneliness.
        * Each cell with four or more neighbors dies, as if by overpopulation.
        * Each cell with two or three neighbors survives.
         For a space that is 'empty' or 'unpopulated'
        * Each cell with three neighbors becomes populated.
=end
  def evolve(neighbors_count)
    #default before evaluation
    @state_changed = false

    #evaluate all neighbors
    case
    when @current_state === false #empty
      #if there are exactly 3 neighbors, it will live
      if neighbors_count == 3 then state = true end
      @state_changed = !state

    when @current_state === true #populated
      #Lonely? - one or none neighbors
      if neighbors_count < 2
        state = false
        @state_changed = true
      end
      #Overpopulated? - four or more neighbors
      if neighbors_count > 3
        state = false
        @state_changed = true
      end
      #Suvives? - two or three neighbors
      if neighbors_count == 2 or neighbors_count == 3
        state = true
        @state_changed = false
      end
    else
     #
    end
    @current_state = (state == true)
    #return age
    if @state_changed
      @lifespan = 0
    else
      @lifespan += 1
    end
  end

  def add_neighbors(ids)
    @neighbors = ids if (ids != nil)
  end

  def neighborhood
    @neighbors
  end

  def state
    @current_state == true
  end

end

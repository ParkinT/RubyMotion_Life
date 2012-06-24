class Cell
  attr_reader :current_state #what we show to the world as state
  attr_accessor :id
  attr_accessor :button #object
  attr_reader :neighborhood

  def initialize(_id, _btn)
    @id = _id
    @button = _btn
    @neighbors = Array.new  #we need to initialize
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
    #evaluate all neighbors
    case
    when @current_state === false #empty
      #if there are exactly 3 neighbors, it will live
      state = (neighbors_count == 3)

    when @current_state === true #populated
      #Lonely? - one or none neighbors
      if neighbors_count < 2 then state = false end
      #Overpopulated? - four or more neighbors
      if neighbors_count > 3 then state = false end
      #Suvives? - two or three neighbors
      if neighbors_count == 2 or neighbors_count == 3 then state = true end
    else
     #
    end
    @current_state = (state == true)
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

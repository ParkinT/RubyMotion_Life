describe "Application 'life'" do
  before do
    @app = UIApplication.sharedApplication

  	btn = UIButton.buttonWithType(UIButtonTypeCustom)
  	btn.frame = [[10, 11], [35, 35] ]

    @cell = Cell.new(0x6a3f620, btn)
  end

  it "maintains state" do
  	@cell.state= false
  	@cell.state.should == false
  	@cell.state= true
  	@cell.state.should == true
  end

  it "tracks change in state" do
  	@cell.state= false
  	@cell.state= true
	@cell.changed?.should == true  	
  end

  it "holds button reference" do
  	@cell.button.should != nil
  	@cell.button.frame.origin.x.should == 10
  	@cell.button.frame.origin.y.should == 11
  end

  describe "obeys rules of life for living cell" do
	before do
		@c = Cell.new(0x6a3f620, 100)
		@c.state=true
	end
	it "lonely cell dies" do
		@c.evolve(0)
		@c.state.should == false
		@c.evolve(1)
		@c.state.should == false
	end 
	it "overpopulated cell dies" do
		@c.evolve(4)
		@c.state.should == false
		@c.evolve(5)
		@c.state.should == false
		@c.evolve(6)
		@c.state.should == false
	end
	it "right balance of neighbors cell survives" do
		@c.evolve(2)
		@c.state.should == TRUE
		@c.evolve(3)
		@c.state.should == TRUE
	end
  end

  describe "obeys rules of life for dead cell" do
	before do
		@c = Cell.new(0x6a3f620, 100)
		@c.state=false
	end
	it "grows with 3 neighbors" do
		@c.evolve(3)
		@c.state.should == TRUE
	end
  end

end
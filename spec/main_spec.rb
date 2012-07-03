describe "Application 'life'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has one window" do
    @app.windows.size.should == 1
  end

  it "builds a world"  do
  	CELL_X_SIZE = 35
  	CELL_Y_SIZE = 35

  	COLS = (UIScreen.mainScreen.applicationFrame.size.width / CELL_X_SIZE).round.to_i
  	ROWS = ((UIScreen.mainScreen.applicationFrame.size.height - 15) / CELL_Y_SIZE).round.to_i
  	TOTAL_CELLS = COLS * ROWS

  	@community.size.should be == TOTAL_CELLS
  end
end

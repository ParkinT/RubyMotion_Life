describe "Application 'life'" do
  before do
    @app = UIApplication.sharedApplication

  end

  it "has one window" do
    @app.windows.size.should == 1
  end

  it "builds a world"  do
  	COLS = (UIScreen.mainScreen.applicationFrame.size.width / 35).round.to_i
  	ROWS = ((UIScreen.mainScreen.applicationFrame.size.height - 15) / 35).round.to_i
  	TOTAL_CELLS = COLS * ROWS

    controller = @app.keyWindow.rootViewController
#    controller.community.size.should == TOTAL_CELLS
    controller.community.size.should > 0
  end

end

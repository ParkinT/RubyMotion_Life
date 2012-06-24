LIFE
----

As an example and exercise for RubyMotion, this is [yet another] implementation of John Conway's LIFE.
2012 Thom Parkin   http://github.com:ParkinT/RubyMotion_Life

The Rules
=========

1. Any live cell with fewer than two live neighbors dies, as if caused by under-population.
2. Any live cell with two or three live neighbors lives on to the next generation.
3. Any live cell with more than three live neighbors dies, as if by overcrowding.
4. Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.

Using The Application
=====================

Initially, a field is displayed that represents a set of 'cells'.  The initial state is dormant (none are alive).
Clicking (touching) a cell will toggle its state.
Once you have set up the field as you wish, "Begin Evolution" will start the process of EVOLVING based on the rules John Conway had set out in 1970.

TODO
====
A decent Splash Screen and Icon(s) would be nice.  But I am a developer and far, far, FAR from a graphic designer or an artist.
The number of Evolution Cycles (iterations) is captured.  It should be displayed to the user.
The time delay between evolution cycles is configurable.  I would like to give the user an easy option to change/test that value.
Add an "I"nformation button that opens a panel listing the 'rules' (above).
Allow pre-loading of setups to begin.  This alleviates the painstaking task of touches to toggle each cell into the initial state you wish.
In the simulator, if you close the application then reopen it, it should reset.  I don't know how to do that with iOS or RubyMotion.
Rather than a simple text representation, there should be an image on each button.
As a cell dies (and is born) the image should 'animate'.
TESTS!!!  Of course, we should have tests.

Please hack on this and, where you see an area for improvement, update it.  I would like to expand my expertise in Ruby Motion and appreciate your experience to guide me.  Don't hesitate to send a pull request.

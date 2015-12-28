
##Unbeatable Tic-Tac-Toe

###Try it out
[http://jon-tic-tac-toe.herokuapp.com/](http://jon-tic-tac-toe.herokuapp.com/)


###Run it locally

###Dependencies:
* ruby/rails
* postgresql
* bundler

###Install steps
* bundle install
* run rake:db create
* run rake db:migrate
* run rake db:seed
    * seed is important as I'm storing the game logic in a database instance.

###Approach
Loosely based on the blog post [here](http://neverstopbuilding.com/minimax) but taking a different approach.
I build a tree of all possible moves partitioned by whether the AI player is on offense (X) or defense (O).  While building the tree,
the algorithm finds a leaf and determines it's end result (win, tie, loss), then goes up the tree labeling a path with one or many of these results.
The path steps are persisted in a database keyed by the game-board's state.  During game play, the AIPlayer takes the games-board's current state, looks up all available options and picks the best path.
All of the above logic can be found in AIPlayerService which handles the training of the AIPlayer.

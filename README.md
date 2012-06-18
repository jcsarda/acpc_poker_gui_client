ACPC Poker Gui Client
======================

The _ACPC_ Poker Gui Client allows people to play poker games against automated agents.  It is still under development, but it currently supports two-player limit and no-limit Texas Hold'em, but has the potential to support three-player as well.

Server Side Requirements for Starting a Game
-----------------------

A <em>Beanstalkd server</em> is used to run background processes. Background processes are required so that game state can persist beyond a single HTTP request.

Obviously, to serve a web page at all, an Apache server must be running and it must point to this application.  This is currently done with Apache + Rails integration through the <em>Phusion Passenger</em> gem.

Application Control Flow
----------------------------

When the user's browser is directed to the address of this application, a request is sent to Rails, which looks in `config/routes.rb` for `root :to => 'new_game#index'`. This routes the application's root address to the `index` _action_ of `NewGameController`.  Control moves into the `index` method of `NewGameController`.  When it drops out of `index`, Rails implicitly renders a _template_ with the same name in the `new_game` directory--`index.html.haml`, in this case.  This template sets up the application's page and renders the <em>partial template</em>, `_index.html.haml`.  `_index.html.haml` presents the initial form to the user.

Match Control Flow
---------------------

To start a match, the web application starts an instance of the dealer and any autonomous agents (commonly called bots) that the user has selected to play against. Bots are started as background processes on the Beanstalkd server.

To communicate to the dealer on the user's behalf, a `WebApplicationPlayerProxy` is started like the dealer and opponent bots themselves through the `stalker` gem and the `script/worker.rb` script that it runs. The `WebApplicationPlayerProxy` shares match state information with the Rails controllers and views  through a `MongoDB` database `Match` model. The `mongoid` gem is used to interact with `MongoDB` on behalf of the app.

`WebApplicationPlayerProxy` utilizes the `acpc_poker_player_proxy` gem to handle the actual communication with the dealer and the management of the match's state. `WebApplicationPlayerProxy` only responsibilies are to then package the data from the `PlayerProxy` instance into a `MatchSlice` model (embedded in the initial `Match` model), for `PlayerActionsController` to retrieve and display, and tell the `PlayerProxy` to send an action from the user (through `PlayerActionsController`) to the dealer.

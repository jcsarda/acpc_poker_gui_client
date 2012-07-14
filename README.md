ACPC Poker Gui Client
======================
The [Annual Computer Poker Competition](http://www.computerpokercompetition.org/) Poker Gui Client provides a GUI interface with which people may play poker games against automated agents. It is still under development, but currently supports two-player limit and no-limit Texas Hold'em, and has the potential to support three-player as well.

This application is built on Ruby and Rails, and a running instance is currently hosted by the [University of Alberta's](http://www.ualberta.ca/) [Computer Poker Research Group](http://poker.cs.ualberta.ca/) [here](http://voldemort.cs.ualberta.ca:8080/).

More details
----------------
* [GitHub][GitHub repo] - Code
* [RubyDoc.info](http://rubydoc.info/github/dmorrill10/acpc_poker_gui_client/master/frames) - Documentation

Components
------------
Much of this application's functionality comes from component gems that began as part of this project and subsequently branched away to become stand-alone projects:

* [ACPC Dealer](https://github.com/dmorrill10/acpc_dealer) - Wraps the [<em>ACPC Dealer Server</em>][competition server link] in a handy gem with a convenient runner class, and a script for compiling and running the dealer and example players.
* [ACPC Dealer Data](https://github.com/dmorrill10/acpc_dealer_data) - Utilities for extracting information from [<em>ACPC Dealer Server</em>][competition server link] logs. Used for mostly for testing.
* [ACPC Poker Basic Proxy](https://github.com/dmorrill10/acpc_poker_basic_proxy) - Utilities for communicating with the [<em>ACPC Dealer Server</em>][competition server link].
* [ACPC Poker Match State](https://github.com/dmorrill10/acpc_poker_match_state) - Provides a manager for the state of a poker match.
* [ACPC Poker Player Proxy](https://github.com/dmorrill10/acpc_poker_player_proxy) - Provides a full proxy through which a match of poker may be played with the [<em>ACPC Dealer Server</em>][competition server link]. Match states sent by the dealer are retrieved automatically whenever they are available, and are interpreted and managed for the user.
* [ACPC Poker Types](https://github.com/dmorrill10/acpc_poker_types) - Fundamental poker types like `Card`, `Player`, `GameDefinition`, and `MatchState`.

Installation
---------------
Download [the code][GitHub repo] and run

    bundle install


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

<!---
  Link references
  ================
-->

[competition server link]: http://www.computerpokercompetition.org/index.php?option=com_rokdownloads&view=folder&Itemid=59
[GitHub repo]: https://github.com/dmorrill10/acpc_poker_gui_client
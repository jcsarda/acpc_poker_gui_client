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

Prerequisites
----------------
* Ruby 1.9.3 - This can be installed in different ways, but a good choice is [RVM](https://rvm.io//). Or you can follow these [instructions](http://www.ruby-lang.org/en/downloads/) to install via a different method.
* Git - While this should only be required if you want to install Ruby via [RVM](https://rvm.io//), installing Git also makes working with this repository easier, so it is recommended. Follow these [instructions](https://help.github.com/articles/set-up-git#platform-all) to do so.


Installation
---------------
Download [the code][GitHub repo], which can be done by running

    git clone git://github.com/dmorrill10/acpc_poker_gui_client.git

then, in the project's root directory, run

    rake install

This should install all the application's dependencies, except [<em>Apache</em>][Apache homepage], including gems, [<em>Beanstalkd</em>][Beanstalkd homepage], and [<em>MongoDB</em>][MongoDB homepage].

Non-gem dependencies
---------------------------
The [<em>Beanstalkd background process server</em>][Beanstalkd homepage] is used to host background processes. Background processes are required so that game state can persist beyond a single HTTP request.

[<em>MongoDB</em>][MongoDB homepage] is used as the database back-end.

Web server
--------------
### Development mode
A Thin server installed via gem serves the application locally in development mode.

### Production mode
An [<em>Apache server</em>][Apache homepage] hosts the application proper in production mode. This is currently done with Apache-Rails integration through [<em>Phusion Passenger</em>][Phusion Passenger homepage]. As [Apache][Apache homepage] is only used in production, it is not required to deploy this application on a local development server.

Deployment
------------
### Development mode
Deploying the application in development mode on a Thin server is simply a matter of running

    rake start_dev_server
in the project's root directory.

### Production mode
Similarly, to deploy in production mode (given that [<em>Apache</em>][Apache homepage] and [<em>Phusion Passenger</em>][Phusion Passenger homepage] are properly configured), run:

    rake start_prod_server

Updates
---------
Updating this application can be done by running

    rake update
in the project's root directory, which will pull the newest down code from the [repository][GitHub repo] and install any missing gems.

These tasks can be done separately too (as can all rake tasks, see the [Rakefile](Rakefile) for more details), with [Git](http://git-scm.com/) and [Bundler](http://gembundler.com/) commands.

Copyright
---------
Copyright &copy; 2012 by the Computer Poker Research Group, University of Alberta. See [LICENSE](LICENSE.md) for details.

<!---
  Link references
  ================
-->

[competition server link]: http://www.computerpokercompetition.org/index.php?option=com_rokdownloads&view=folder&Itemid=59
[GitHub repo]: https://github.com/dmorrill10/acpc_poker_gui_client
[Beanstalkd homepage]: http://kr.github.com/beanstalkd/
[MongoDB homepage]: http://www.mongodb.org/
[Apache homepage]: http://www.apache.org/
[Phusion Passenger homepage]: http://www.modrails.com/

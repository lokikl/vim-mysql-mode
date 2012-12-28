# VIM MySQL Mode #

This plugin will allow you to replace the command line mysql client with vim,
you may edit queries with full power of VIM. Result will be showed in a split window.


## Installation ##

I recommand you to install this plugin with Vundle, just add this line to your .vimrc:

    Bundle "loki-nkl/vim-mysql-mode"


## Usage ##

First, please enter the MySQL Mode with:

    :MySQLMode

Information like host, port, db name, username and password will be asked before setting up
the connection. If you want to reset the connection, just execute :MySQLMode again.

You will then see two split windows, please enter your mysql queries inside the bottom one.
Now when you press the <F5> button in normal mode, your queries will be executed and result will be
showed in the top split.

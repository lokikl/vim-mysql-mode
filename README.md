# VIM MySQL Mode #

This plugin is a replacement of the command line mysql client.
You may edit queries with full power of VIM and shows results in a split window.


## Installation ##

I recommand you to install this plugin with Vundle, just add this line to your .vimrc:

    Bundle "loki-nkl/vim-mysql-mode"


## Usage ##

First, please enter the MySQL Mode with:

    :MySQLMode

Information like host, port, db name, username and password are asked for setting up connection.
If you want to reset connection, just execute :MySQLMode again.

You should then see two split windows. Let's enter some mysql queries inside the bottom one.
Now go to normal mode and press the F5 key, your queries are executed and you should see the
result in the top split.


## Misc ##

Also encouraging you to use this plugin with Syntastic and Ultisnips, having the power of
syntax checking and snippet support.

Personally, I launch this vim mysql console directly through a shell command.

    function vimsql(){
      gvim -c "let g:mysqlModeDBName='$1' | ruby enter_mysql_mode"
    }
    
With the autocompletion power from zsh.

    #compdef vimsql
    #autoload
    compadd -x 'DBs' `mysql -uroot -e 'show databases \G' | grep Database | awk '{print $2}'`

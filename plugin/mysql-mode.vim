" mysql mode
" by Loki Ng
" ==============================================================================
if !exists("g:mysqlModeHost")
  let g:mysqlModeHost="127.0.0.1"
endif

if !exists("g:mysqlModePort")
  let g:mysqlModePort="3306"
endif

if !exists("g:mysqlModeDBName")
  let g:mysqlModeDBName="cloudengine"
endif

if !exists("g:mysqlModeUsername")
  let g:mysqlModeUsername="root"
endif

if !exists("g:mysqlModePassword")
  let g:mysqlModePassword=""
endif

command! MySQLMode ruby mysql_mode

ruby <<EOF
undef vim_exec if respond_to? :vim_exec
def vim_exec *args
  args.each { |cmd| VIM::command cmd }
end

undef prompt if respond_to? :prompt
def prompt text, default=nil
  vim_exec 'call inputsave()'
  vim_exec "let input = input('#{text} [#{default}]: ')"
  vim_exec "call inputrestore()"
  input = VIM::evaluate "input"
  if input != ""
    input
  elsif !default.nil?
    default
  else
    raise "This input is required but missing, aborted!"
  end
end

undef get_var if respond_to? :get_var
def get_var name
  VIM::evaluate("g:#{name}")
end

undef set_var if respond_to? :set_var
def set_var name, value
  VIM::command "let g:#{name}='#{value}'"
end

undef reset_var if respond_to? :reset_var
def reset_var name, desc
  v = prompt desc, get_var(name)
  set_var name, v
end

undef get_content if respond_to? :get_content
def get_content
  buffer = VIM::Buffer.current
  content = ""
  buffer.length.times { |i|
    content << buffer[i + 1]
  }
  content
end

undef mysql_mode if respond_to? :mysql_mode
def mysql_mode
  vim_exec "set filetype=mysql"
  reset_var "mysqlModeHost", "Host"
  reset_var "mysqlModePort", "Port"
  reset_var "mysqlModeDBName", "DB Name"
  reset_var "mysqlModeUsername", "Username"
  reset_var "mysqlModePassword", "Password"
  vim_exec 'echo ""', 'echo "\nEntered MySQL Mode"'
  vim_exec "wincmd n", "wincmd w" if VIM::Window.count < 2
  vim_exec "noremap <F5> :ruby execute_mysql<cr>"
end

undef execute_mysql if respond_to? :execute_mysql
def execute_mysql
  cmd = get_content
  vim_exec "wincmd w", "normal ggdG"
  host      = get_var 'mysqlModeHost'
  port      = get_var 'mysqlModePort'
  db        = get_var 'mysqlModeDBName'
  username  = get_var 'mysqlModeUsername'
  password  = get_var 'mysqlModePassword'
  passcmd   = password && password != "" ? "-p#{password}" : ""
  res = `mysql --default-character-set=utf8 -h#{host} -P#{port} -u#{username} #{passcmd} #{db} -vvv -e '#{cmd}' 2>&1`
  res = res.split("\n")
  res = res[0..-3] if res.count > 1
  res.each_with_index { |l, i|
    VIM::Buffer.current.append i, l
  }
  vim_exec "normal G", "wincmd w"
end
EOF

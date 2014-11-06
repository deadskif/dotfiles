set nocp
filetype plugin on
filetype indent on
set nu
set nowrap
set iskeyword=@,48-57,_,192-255

if has("gui_running")
	set guifont=terminus
	colorscheme gentooish
else
	colorscheme elflord
endif

"vmap <C-C> "+yi
"imap <C-V> <esc>"+gPi
nmap T :tabnew
nmap t :tabnew<CR>
set sw=4
set et
"if syntax == 'python' 
"	set et  
"	set sw=4
"	set sts=4
"endif
"let ctags_command
":colors murphy
set so=7
":setlocal spell spelllang=en
":set softtabstop=2
":set et
set spelllang=tu_yo,en_us

map ё `
map й q
map ц w
map у e
map к r
map е t
map н y
map г u
map ш i
map щ o
map з p
map х [
map ъ ]
map ф a
map ы s
map в d
map а f
map п g
map р h
map о j
map л k
map д l
map ж ;
map э '
map я z
map ч x
map с c
map м v
map и b
map т n
map ь m
map б ,
map ю .
map Ё ~
map Й Q
map Ц W
map У E
map К R
map Е T
map Н Y
map Г U
map Ш I
map Щ O
map З P
map Х {
map Ъ }
map Ф A
map Ы S
map В D
map А F
map П G
map Р H
map О J
map Л K
map Д L
map Ж :
map Э "
map Я Z
map Ч X
map С C
map М V
map И B
map Т N
map Ь M
map Б <
map Ю >

"set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
"imap :!setxkbmap us:!setxkbmap us,ru
"nmap :!setxkbmap us:!setxkbmap us,ru
"

set foldenable
set foldmethod=indent


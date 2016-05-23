" Gentoo-based version
" use app-vim/{airline,gitgutter,nerdtree,bufexplorer,dirdiff,vim-spell-{en,ru},fugitive}
" use media-fonts/powerline-fonts::raiagent[anonymouspro,dejavusansmono,droidsansmono,liberationmono,terminus_pcf]
"call pathogen#infect()
filetype indent plugin on
syntax enable
set ofu=syntaxcomplete#Complete
set completeopt=menu

set tabstop=4
set shiftwidth=4
set expandtab

set fileencodings=utf8,cp1251,koi8r,cp866

set nu
"set background=dark
set nowrap
set iskeyword=@,48-57,_,192-255

"colorscheme molokai
"colorscheme desert
colorscheme jellybeans
if has("gui_running")
    set guioptions=aegimrltT
	set guifont=terminus
	"colorscheme gentooish
    setlocal spell spelllang=ru,en
    let g:airline_powerline_fonts = 1
else
    set mouse=a
endif

set cursorline
" Поиск по набору текста (очень полезная функция)
set incsearch
" Опции сесссий
set sessionoptions=curdir,buffers,tabpages
" Не выгружать буфер, когда переключаемся на другой
" Это позволяет редактировать несколько файлов в один и тот же момент без необходимости сохранения каждый раз
" когда переключаешься между ними
set hidden
"vmap <C-C> "+yi
"imap <C-V> <esc>"+gPi
nmap T :tabnew
nmap t :tabnew<CR>
"set sw=4
"set et
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
"set spelllang=tu_yo,en_us

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
set foldmethod=syntax
nmap <C-N>v :NERDTree<cr>
vmap <C-N>v <esc>:NERDTree<cr>i
imap <C-N>v <esc>:NERDTree<cr>i
"nmap <C-N>v :NERDTreeTabsOpen<CR>
"vmap <C-N>v <esc>:NERDTreeTabsOpen<CR>i
"imap <C-N>v <esc>:NERDTreeTabsOpen<CR>i

let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'

nmap <C-N>x :NERDTreeClose<cr>
vmap <C-N>x <esc>:NERDTreeClose<cr>i
imap <C-N>x <esc>:NERDTreeClose<cr>i
"nmap <C-N>x :NERDTreeTabsClose<CR>
"vmap <C-N>x <esc>:NERDTreeTabsClose<CR>i
"imap <C-N>x <esc>:NERDTreeTabsClose<CR>i

" F5 - просмотр списка буферов
nmap <F5> <Esc>:BufExplorer<cr>
vmap <F5> <esc>:BufExplorer<cr>
imap <F5> <esc><esc>:BufExplorer<cr>

" F6 - предыдущий буфер
map <F6> :bp<cr>
vmap <F6> <esc>:bp<cr>i
imap <F6> <esc>:bp<cr>i

" F7 - следующий буфер
map <F7> :bn<cr>
vmap <F7> <esc>:bn<cr>i
imap <F7> <esc>:bn<cr>i

inoremap <C-Space> <C-X><C-O>
"inoremap <Menu> <C-X><C-O>
"
function ReCTags()
    ":!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
    ":!ctags -R --extra=+f --fields=+Szt .
    :!ctags -R --c++-kinds=+pcd --fields=+iaSzl --extra=+qf .
    echo "Tags regenerated"
endfunction
function ReSystemCTags()
    :!ctags -R --c++-kinds=+pcd --fields=+iaSzl --extra=+qf /usr/include/*.h -f ~/.vim/ctags/tags
    :!ctags -R --c++-kinds=+pcd --fields=+iaSzl --extra=+qf -a /usr/include/sys/*.h -f ~/.vim/ctags/tags
    echo "Tags regenerated"
endfunction

set tags+=~/.vim/ctags/tags

function RePyTags()
    :!ctags -R --python-kinds=-i --fields=+iaSz --extra=+qf .
    echo "Tags regenerated"
endfunction

function SaveSession()
    :mksession! session.vim
    echo "Session resaved"
endfunction
if file_readable('tags')
    "call ReCTags()
endif
map <silent> <leader>2 :diffget 2<CR> :diffupdate<CR>
map <silent> <leader>3 :diffget 3<CR> :diffupdate<CR>
map <silent> <leader>4 :diffget 4<CR> :diffupdate<CR>

set laststatus=2
highlight clear SignColumn

" GitGutter
"nmap [h <Plug>GitGutterPrevHunk
"nmap ]h <Plug>GitGutterNextHunk
"nmap <Leader>hs <Plug>GitGutterStageHunk
"nmap <Leader>hr <Plug>GitGutterRevertHunk


let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

"let g:airline#extensions#hunks#enabled = 1
"let g:airline#extensions#branch#enabled = 1
"let g:airline#extensions#branch#empty_message = '<!!>'


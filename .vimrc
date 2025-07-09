source $VIMRUNTIME/defaults.vim	" nacita systemovy konfigurak

set number		" zobrazi cisla riadkov
" set shiftwidth=2	" odsadenie v xv6 su 2 medzery
set hlsearch		" oznaci posledny hladany vyraz
set ignorecase		" case-insensitive vyhladavanie
set smartcase		" pri velkom pismene vo vyraze case-sensitive
set smarttab		" <Tab> spravne odsadi text na zaciatku riadka
set expandtab		" automaticky pouzije medzery namiesto tabulatorov
set autoread		" obnovi subor pri externej zmene
set hidden		" pri prepinani buffera ho nie je potrebne ulozit
set laststatus=2	" stavovy riadok bude vzdy zobrazeny
set showmatch		" zvyrazni parovu zatvorku
packadd! matchit	" plugin, ktory vylepsuje %
set path+=**		" :find vyhlada aj podadresare
let c_space_errors = 1  " vyznaci opustene prazdne znaky
set scrolloff=0         " kurzor moze byt umiestneny na okraji obrazovky

" prikaz na vytvorenie tagov
command! MakeTags !ctags -R .
set tags=./tags;		" hlada subor 'tags' smerom ku korenu fs

" rychlejsi presun medzi oknami
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" po otvoreni suboru presunie kurzor na posledne miesto upravy
" vid :help restore-cursor
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" perzistentne undo (historia ostane aj po zavreti suboru)
set undodir=~/.vim_runtime/temp_dirs/undodir
set undofile

au BufRead,BufNewFile *.md setlocal textwidth=80

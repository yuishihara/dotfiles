autocmd BufReadPost,BufNewFile *.bin,*.exe,*.dll setlocal filetype=xxd
autocmd BufRead,BufNewFile *.hpp setlocal filetype=cpp
autocmd BufRead,BufNewFile *.gradle setlocal filetype=groovy
autocmd BufRead,BufNewFile *.json setlocal filetype=json
autocmd BufReadPost,BufNewFile .*exports,.*aliases,.*path,.*extra,.*bashrc setlocal filetype=sh
autocmd BufRead,BufNewFile *.m,*.oct set filetype=octave
autocmd BufRead,BufNewFile *.rs set filetype=rust

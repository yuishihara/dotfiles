autocmd BufReadPost,BufNewFile *.bin,*.exe,*.dll setlocal filetype=xxd
autocmd BufRead,BufNewFile *.hpp setlocal filetype=cpp
autocmd BufRead,BufNewFile *.gradle setlocal filetype=groovy
autocmd BufReadPost,BufNewFile .*exports,.*aliases,.*path,.*extra setlocal filetype=sh

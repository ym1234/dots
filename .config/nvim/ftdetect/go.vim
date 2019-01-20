nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" TODO(ym): Better keybind
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>


let g:SuperTabDefaultCompletionType = "<c-x><c-o>" " makes supertab use omnicompletion functions

" allow gf to work with PHP namespaced classes.
set path+=**
set includeexpr=substitute(v:fname,'\\\','/','g')
set suffixesadd+=.php
set tabstop=4
set shiftwidth=4

setlocal omnifunc=phpcomplete_extended#CompletePHP

" php.vim
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

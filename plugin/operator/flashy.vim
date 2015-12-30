"=============================================================================
" FILE: plugin/operator/flashy.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_operator_flashy
endif
if exists('g:loaded_operator_flashy')
  finish
endif
let g:loaded_operator_flashy = 1
let s:save_cpo = &cpo
set cpo&vim

call operator#user#define('flashy', 'operator#flashy#do')
vnoremap <silent> <Plug>(operator-flashy) y
onoremap <expr><silent> <Plug>(operator-flashy) operator#flashy#o_y()

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

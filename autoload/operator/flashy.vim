"=============================================================================
" FILE: autoload/operator/flashy.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('operator_flashy')
let s:Highlight = s:V.import('Coaster.Highlight')
let s:Search = s:V.import('Coaster.Search')

let g:operator#flashy#group = get(g:, 'operator#flashy#group', 'Flashy')
let g:operator#flashy#flash_time = get(g:, 'operator#flashy#flash_time', 100)

function! s:init_hl() abort
  highlight Flashy term=bold ctermbg=0 guibg=#13354A
endfunction

call s:init_hl()

augroup plugin-flashy-highlight
  autocmd!
  autocmd ColorScheme * call s:init_hl()
augroup END

" operator#flashy#do() yanks text with flash in normal mode.
" It doesn't provie mapping for visual mode and doesn't support 'block' wise.
" @param {'char'|'line'|'block'} wise
function! operator#flashy#do(wise) abort
  if s:is_empty_region()
    return
  endif

  " Save cursor position for linewise motion like 'yj'.
  if a:wise is# 'line'
    let w = winsaveview()
  endif

  let visual_command = operator#user#visual_command_from_wise_name(a:wise)
  let pattern = s:Search.pattern_by_range(visual_command, getpos("'[")[1:], getpos("']")[1:])
  call s:flash(pattern)
  call s:yank(visual_command)

  " Restore cursor position for linewise motion like 'yj'.
  if a:wise is# 'line'
    call winrestview(w)
  endif
endfunction

" o_y() keeps cursor position for linewise motion like 'yy'.
" Example:
"   onoremap <expr> y operator#flashy#o_y()
function! operator#flashy#o_y() abort
  let save_cursor = getcurpos()
  let rest_cursor = ":call setpos('.'," .  string(save_cursor) . ")\<CR>"
  return "\<Esc>\"" . operator#user#register() . v:count . 'g@g@' . rest_cursor
endfunction

function! s:flash(pattern) abort
  call s:Highlight.highlight('YankRegion', g:operator#flashy#group, a:pattern, 10)
  redraw
  call s:sleep(g:operator#flashy#flash_time)
  call s:clear()
endfunction

function! s:sleep(ms) abort
  execute 'sleep' g:operator#flashy#flash_time . 'ms'
endfunction

function! s:clear() abort
  call s:Highlight.clear('YankRegion')
endfunction

function! s:yank(visual_command) abort
  let original_selection = &g:selection
  let &g:selection = 'inclusive'
  let reg = operator#user#register()
  execute 'normal!' '`[' . a:visual_command . '`]"' . reg . 'y'
  let &g:selection = original_selection
endfunction

" :h cpo-E
function! s:is_empty_region() abort
  return line("'[") is# line("']") + 1
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

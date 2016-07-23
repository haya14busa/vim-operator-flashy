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
  highlight default Flashy term=bold ctermbg=0 guibg=#13354A
  if hlexists('Cursor')
    highlight default link FlashyCursor Cursor
  else
    highlight default FlashyCursor term=reverse cterm=reverse gui=reverse
  endif
endfunction

call s:init_hl()

augroup plugin-flashy-highlight
  autocmd!
  autocmd ColorScheme * call s:init_hl()
augroup END

" operator#flashy#do() yanks text with flash in normal mode.
" It assumes not to provide mappings for visual mode.
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
  let start = [line("'["), virtcol("'[")]
  let end = [line("']"), virtcol("']")]
  let pattern = s:Search.pattern_by_range(visual_command, start, end)
  " Call s:yank() first to show information while flashing.
  " e.g. 14lines yanked
  call s:yank(visual_command)
  call s:flash(pattern, g:operator#flashy#flash_time)

  " Restore cursor position for linewise motion like 'yj'.
  if a:wise is# 'line'
    call winrestview(w)
  endif
endfunction

" o_y() keeps cursor position for linewise motion like 'yy'.
" Example:
"   onoremap <expr> y operator#flashy#o_y()
function! operator#flashy#o_y() abort
  let cursor = getpos('.')
  let yank = "\<Esc>\"" . operator#user#register() . v:count1 . 'yy'
  return printf("%s:call operator#flashy#_o_y(%s)\<CR>", yank, string(cursor))
endfunction

function! operator#flashy#_o_y(cursor_pos) abort
  call setpos('.', a:cursor_pos)
  let pattern = printf('\%%%dl\_.*\%%%dl', line("'["), line("']"))
  " Turn off cursorline temporalily because redraw of highlight line with
  " cursorline is too slow in large file.
  " ref: https://github.com/haya14busa/vim-operator-flashy/issues/5
  let cursorline_save = &cursorline
  let &cursorline = 0
  try
    call s:flash(pattern, g:operator#flashy#flash_time)
  finally
    let &cursorline = cursorline_save
  endtry
endfunction

function! s:flash(pattern, time) abort
  try
    call s:highlight_cursor()
    call s:highlight_yanked_region(a:pattern)
    redraw
    call s:sleep(a:time)
  finally
    call s:clear()
  endtry
endfunction

function! s:sleep(ms) abort
  let t = reltime()
  while !getchar(1) && a:ms - str2float(reltimestr(reltime(t))) * 1000.0 > 0
  endwhile
endfunction

function! s:highlight_cursor() abort
  " Do not highlight cursor if the character under cursor is Tab character
  " because it has more than one width and the cursor highlight will be
  " ugly.
  if s:get_cursor_char() isnot# "\t"
    call s:Highlight.highlight('FlashyCursor', 'FlashyCursor', '\%#', 11)
  endif
endfunction

function! s:get_cursor_char() abort
  return getline('.')[col('.')-1]
endfunction

function! s:highlight_yanked_region(pattern) abort
  call s:Highlight.highlight('YankRegion', g:operator#flashy#group, a:pattern, 10)
endfunction

function! s:clear() abort
  call s:Highlight.clear('FlashyCursor')
  call s:Highlight.clear('YankRegion')
endfunction

function! s:yank(visual_command) abort
  let reg = operator#user#register()
  execute 'normal!' '`["' . reg . 'y' . a:visual_command . '`]"'
endfunction

" :h cpo-E
function! s:is_empty_region() abort
  return line("'[") is# line("']") + 1
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker

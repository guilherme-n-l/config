" --- Prelude ---

if !exists('g:env')
    if has('win64') || has('win32') || has('win16')
        let g:env = 'WINDOWS'
    else
        let g:env = toupper(trim(system('uname')))
    endif
endif

" --- Looks ---

set nu
set rnu
set ru
set noswf
syntax on

" --- Remaps ---

let mapleader = " "
let s:REMAPS = {
    \ 'n': [
        \'<leader>x :bd<CR>',
        \ 'J mzJ`z',
        \ '<C-d> <C-d>zz',
        \ '<C-u> <C-u>zz',
        \ 'n nzzzv',
        \ 'N Nzzzv',
        \ '<leader>pf :Ex<CR>'
    \],
    \ 'v': [
        \ "K :m '<-2<CR>gv=gv",
        \ "J :m '>+1<CR>gv=gv"
    \],
    \ 'nvx': [
        \ '<leader>y "+y',
        \ '<leader>d "+d',
        \ '<leader>p "+p'
    \]
\ }

function s:CreateRemaps()
    for [k, v] in items(s:REMAPS)
        for c in split(k, '\zs')
            for km in v
                execute c . 'noremap ' . km
            endfor
        endfor
    endfor
endfunction

call s:CreateRemaps()


" --- Commands ---

" :Uniq - Removes duplicate lines in the given range
" Usage:
"   :<range>Uniq      - Sorts lines and removes duplicates
"   :<range>Uniq!     - Sorts lines and keep ones which were already unique
command! -range=% -bang Uniq <line1>, <line2>call s:Uniq(<bang>0)
function! s:Uniq(bang) range
    execute printf('%d,%dsort', a:firstline, a:lastline)
    if a:bang
        let found = {}
        for l in getline(a:firstline, a:lastline)
            let found[l] = has_key(found, l)
        endfor
        call filter(found, { _, v -> !v })
        let lines = keys(found)
        for i in range(0, len(lines) - 1)
            call setline(a:firstline + i, lines[i])
        endfor
        let len_lines = len(lines)
        if len_lines < (a:lastline - a:firstline + 1)
            execute printf('%d,%ddelete _', a:firstline + len_lines, a:lastline)
        endif
    else
        execute printf('silent %d,%dg/\(.*\)\n\1$/d', a:firstline, a:lastline)
    endif
endfunction

" :ToList - Convert lines to list
"
" Usage:
"   :<range>ToList    - Trims lines and converts them to a line of strings
"
command! -range=% ToList <line1>, <line2>call s:ToList()
function! s:ToList() range
    for i in range(a:firstline, a:lastline)
        let prefix = i == a:firstline? '[' : ''
        let suffix = i == a:lastline ? ']' : ','
        call setline(i, printf('%s"%s"%s', prefix, trim(getline(i)), suffix))
    endfor
endfunction


let s:INVOKE = {
    \ 'WINDOWS': [ 'powershell', '-NoLogo', '-Command', 'Start-Process' ],
    \ 'LINUX': [ 'xdg-open' ],
    \ 'DARWIN': [ 'open' ]
\}

" :OpenWindow - Convert lines to ES `window.open` command
"
" Usage:
"   :<range>OpenWindow   - Trims lines and converts them to `window.open` command
"   :<range>OpenWindow!  - Tries to open in browser
"
command! -bang -range=% -nargs=? OpenWindow <line1>, <line2>call s:OpenWindow(<bang>0, <f-args>)
function! s:OpenWindow(bang, ...) range
    let url = a:0 > 0 ? a:1 : ''

    let ParseUrl = {placeholder -> substitute(
        \ url =~ '{}' 
            \ ? url 
            \ : (url ==# '' 
                \ ? '{}' 
                \ : substitute(url, '/\+$', '/{}', '')),
        \ '{}',
        \ placeholder, 'g'
    \ )}

    let ParseUrl = {placeholder -> len(url)
        \ ? url =~ '{}'
            \ ? substitute(url, '{}', placeholder, 'g')
            \ : substitute(url, '/*$', '/' . placeholder, '')
        \ : placeholder
    \}

    if a:bang
        for i in range(a:firstline, a:lastline)
            let ln = trim(getline(i))
            if !len(ln)
                continue
            endif
            let cmd = map(copy(s:INVOKE[g:env]), {i, v -> i ? shellescape(v) : v})
            call add(cmd, ParseUrl(ln))
            call system(join(cmd, " "))
        endfor
    else
        execute printf('silent %d,%dToList',
            \ a:firstline,
            \ a:lastline)
        call setline(a:lastline,
            \ getline(a:lastline) . printf('.forEach(i => window.open("%s"))',
            \ ParseUrl('${i}')))
    endif
endfunction

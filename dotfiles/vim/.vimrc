" --- Looks ---

set nu
set rnu
set ru
syntax on

" --- Remaps ---

let mapleader = " "
let remaps = {
            \ 'n': [ '<leader>x :bd<CR>', 'J mzJ`z', '<C-d> <C-d>zz', '<C-u> <C-u>zz', 'n nzzzv', 'N Nzzzv' ],
            \ 'v': [ "K :m '<-2<CR>gv=gv", "J :m '>+1<CR>gv=gv" ],
            \ 'nvx': [ '<leader>y "+y', '<leader>d "+d' ]
            \ }

for [k, v] in items(remaps)
    for c in split(k, '\zs')
        for km in v
            execute c . 'noremap ' . km
        endfor
    endfor
endfor


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
        echo lines
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
        let suffix = i == a:lastline ? ']' : ''
        call setline(i, printf('%s"%s"%s', prefix, trim(getline(i)), suffix))
    endfor
endfunction

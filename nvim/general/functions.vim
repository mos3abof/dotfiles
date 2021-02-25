" Turn spellcheck on for markdown files
augroup auto_spellcheck
  autocmd BufNewFile,BufRead *.md setlocal spell
augroup END

" strip trailing whitespace
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" function! PythonVenvExecutable()
"   " Give up if we're not looking at a Python buffer
"   if &filetype !=# 'python'
"     return
"   endif
"
"   " Try to get Projectionist root directory name
"   let l:venv_name = fnamemodify(projectionist#path(), ':t')
"
"   " Fall back to Git repo name
"   if l:venv_name ==# ''
"     let l:venv_name = fnamemodify(fugitive#extract_git_dir(@%), ':h:t')
"   endif
"
"   " Default to global Python/pylint
"   let l:python_binary = '/usr/bin/python'
"   let l:pylint_binary = '/usr/local/bin/pylint'
"
"   " Use the virtual environment Python/pylint if it exists
"   let l:venv_root = $WORKON_HOME.'/'.l:venv_name
"   if l:venv_name !=# '.' && isdirectory(l:venv_root)
"     let l:python_binary = l:venv_root.'/bin/python'
"     let l:pylint_binary = l:venv_root.'/bin/pylint'
"   endif
"
"   " Configure ALE
"   let b:ale_python_pylint_executable = l:pylint_binary
"
"   " Configure Completor
"   if exists('g:completor_python_binary')
"     if l:python_binary !=# g:completor_python_binary
"       " If we've changed environments
"       let g:completor_python_binary = l:python_binary
"       silent call completor#daemon#kill()
"     endif
"   else
"     " If this is the first Python buffer in the session
"     let g:completor_python_binary = l:python_binary
"   endif
" endfunction
" autocmd BufWinEnter,WinEnter * :call PythonVenvExecutable()

" vimplugs.vim

if exists('g:vimplugs_loaded')
  finish
endif
let g:vimplugs_loaded = 1

" full path to the directory where this script is located
" note: this expression must be evaluated outside of a function
let s:vimplugs_dir = expand(expand("<sfile>:p:h"))
" set config file name/location
let s:config_file = s:vimplugs_dir. '/vimplugs.conf'
" set plugins directory name/location
let s:plugins_dir = s:vimplugs_dir. '/plugins'

function s:run()
  if !filereadable(s:config_file)
    call s:abort("Could Not Read Configuration File '". s:config_file. "'")
  endif
  if !isdirectory(s:plugins_dir)
    call s:abort("Directory '". s:plugins_dir. "' Not Found")
  endif

  call s:load_config()
  call s:update_runtimepath()
  call s:cycle_filetype()
  call s:install_helptags_helpers()
endfunction

function s:load_config()
  let s:vimplugs = {} " { name: full_path }

  for l:line in readfile(s:config_file)
    let l:line = substitute(l:line, '^\s\+', '', '')
    if !empty(l:line) && strpart(l:line, 0, 1) != '#'
      let l:name = split(l:line)[0]
      let l:dir = s:plugins_dir. '/'. l:name
      if isdirectory(l:dir)
        let s:vimplugs[l:name] = l:dir
      endif
    endif
  endfor
endfunction

function s:update_runtimepath()
  let l:plugin_dirs = join(values(s:vimplugs), ',')
  let l:after_dirs = map(values(s:vimplugs), 'v:val. "/after"')
  let l:after_dirs = filter(l:after_dirs, 'isdirectory(v:val)')
  let l:afters = join(l:after_dirs, ',')
  let &g:runtimepath = join([l:plugin_dirs, &g:runtimepath, l:afters], ',')
endfunction

function s:cycle_filetype()
  if exists('g:did_load_filetypes')
    filetype off
    filetype on
  endif
endfunction

function s:install_helptags_helpers()

  " HelpTags command line completion
  function VimPlugsHelpTagNames(arg_lead, cmd_line, cursor_pos)
    return "--All--\n". join(sort(keys(s:vimplugs)), "\n")
  endfunction

  " called by the HelpTags command
  function VimPlugsCallHelpTags(...)
    if a:0
      if index(a:000, '--All--') >= 0
        let l:plugin_dirs = values(s:vimplugs)
      else
        let l:plugin_dirs = []
        let i = 0
        while i < a:0
          if has_key(s:vimplugs, a:000[i])
            call add(l:plugin_dirs, s:vimplugs[a:000[i]])
          endif
          let i += 1
        endwhile
      endif
      " call :helptags for each plugin's /doc directory
      for l:dir in l:plugin_dirs
        let l:doc_dir = l:dir. '/doc'
        if !empty(glob(l:doc_dir. '/*'))
          execute 'helptags '. l:doc_dir
        endif
      endfor
    endif
  endfunction

  " :HelpTags command
  command -nargs=* -complete=custom,VimPlugsHelpTagNames
    \ HelpTags call VimPlugsCallHelpTags(<f-args>)

endfunction

function s:abort(msg)
  echoerr 'vimplugs failed! : '. a:msg
  finish
endfunction

call s:run()

" clean up
" only the s:vimplugs Dictionary and the :HelpTags functions need to remain
delfunction s:run
delfunction s:load_config
delfunction s:update_runtimepath
delfunction s:cycle_filetype
delfunction s:install_helptags_helpers
delfunction s:abort
unlet s:vimplugs_dir
unlet s:config_file
unlet s:plugins_dir

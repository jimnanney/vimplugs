vimplugs
========

Another Vim plugin management solution...


Install vimplugs
----------------

Clone this repo (or your own fork) into `~/.vim/vimplugs`

```
$ git clone git://github.com/burns/vimplugs ~/.vim/vimplugs
```

Note: The location and directory name here can actually be anything you like (see 'Wrapping up' below).


Configure your plugins
----------------------

Copy the `vimplugs.conf.example` to `vimplugs.conf`

```
$ cp ~/.vim/vimplugs/vimplugs.conf.example ~/.vim/vimplugs/vimplugs.conf
```

Edit `~/.vim/vimplugs/vimplugs.conf` and add whatever Vim plugins you need, one per line.

```
# plugin_name  git_url
matchit  git://github.com/vim-scripts/matchit.zip.git

# plugin_name will be used for the plugin's directory
# e.g. ~/.vim/vimplugs/plugins/matchit/

# leading spaces are ignored
  vim-ruby  git://github.com/vim-ruby/vim-ruby.git -> anything after the url is ignored

# to disable a plugin, simply comment the line
# taglist  git://github.com/vim-scripts/taglist.vim.git
```

Note: The `vimplugs.conf` file must exist. However, you can create a symlink for this (see 'Wrapping up' below).


Install your plugins
--------------------

To install your plugins, run `vimplugs update`

```
$ ~/.vim/vimplugs/vimplugs update
```

I recommend you create a symbolic link for this so it's in your `$PATH`, like `~/bin` or `/usr/local/bin`

```
$ ln -s ~/.vim/vimplugs/vimplugs ~/bin/vimplugs
```

So, with this in place, no matter where you are, you simply run:

```
$ vimplugs update
```

This will clone each of your configured plugins into `~/.vim/vimplugs/plugins/`


Updating installed plugins
--------------------------

The same command is used to install or update all your plugins.

If you just want to install or update certain plugins you have in your `vimplugs.conf`, use:

```
$ vimplugs update matchit,vim-ruby
```


Updating vimplugs itself
------------------------

To update `vimplugs`, you can simply `git pull` from the directory where you cloned it.

However, to make this simple, `vimplugs` has a command that does this for you:

```
$ vimplugs update --system
```


Configuring Vim
---------------

Now that you're managing your plugins, you need them to work :)

Simply source the `~/.vim/vimplugs/vimplugs.vim` file in the top of your `~/.vimrc`

```vim
" your .vimrc

set nocompatible " should be after this

source $HOME/.vim/vimplugs/vimplugs.vim

" then, everything else...
filetype plugin indent on
syntax on
" etc, etc...
```

All your enabled plugins will now be added to Vim's runtimepath.


Help tags
---------

To generate the help tags for your plugins, in Vim type `:HelpTags` and hit &lt;space&gt; &lt;Tab&gt;.
Command line completion will let you select as many of your plugin names as needed, or you can select `--All--`
to generate all available help tags.

Note: When each plugin is cloned, `doc/tags` is added to the cloned repo's `.git/info/excludes` file so generated help
tags won't flag the plugin's folder as being updated in `git status`.


Wrapping up
-----------

As you can now see, the location of the `vimplugs` folder can be anything, as long as you source `vimplugs.vim` from
that location. All paths used by `vimplugs.vim` and the `vimplugs` ruby script are built based on the file's location.
The only requirements is that `vimplugs.conf` (or a symlink) exists in the same directory as these files, and that this
directory contains the `plugins` subdirectory (which could also be a symlink). Also, the name/location of the
`vimplugs.conf` file and the name/location of the `plugins/` folder are both set _once_ in the top of each script, so
this could be easily changed as well.

**Recommended Setup:**
  Assuming you keep your `~/.vim` directory under Git source control :)

  - Clone _vimplugs_ into `~/.vim/vimplugs`
  - Add `vimplugs/` to the `.gitignore` for your `~/.vim` git repo
  - Copy `vimplugs.conf.example` to `~/.vim/vimplugs.conf` and add this file to your repo
  - Create a symlink for it: `ln -s ~/.vim/vimplugs.conf ~/.vim/vimplugs/vimplugs.conf`
  - Create a symlink for the `vimplugs` script somewhere like `~/bin` so it's in your `$PATH`

  If you don't want to ignore the vimplugs/ directory, it will become a subproject for your repo. In this case, you
  probably want to add it using a submodule, like: `git submodule add git://github.com/burns/vimplugs.git vimplugs`

  This project includes it's own `.gitignore`, which will ignore the `vimplugs.conf` file and the `plugins/` directory.

:flashlight: vim-operator-flashy: Highlight yanked area
=======================================================

[![](http://img.shields.io/github/tag/haya14busa/vim-operator-flashy.svg)](https://github.com/haya14busa/vim-operator-flashy/releases)
[![](http://img.shields.io/github/issues/haya14busa/vim-operator-flashy.svg)](https://github.com/haya14busa/vim-operator-flashy/issues)
[![](http://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![](https://img.shields.io/badge/doc-%3Ah%20operator--flashy.txt-red.svg)](doc/operator-flashy.txt)

:flashlight: Introduction :flashlight:
--------------------------------------

Flash yanked area :flashlight:

![i/flashy_key.gif at f04722bfb519570aea79903d976c642e9099606c · haya14busa/i](https://github.com/haya14busa/i/blob/f04722bfb519570aea79903d976c642e9099606c/vim-operator-flashy/flashy_key.gif)

You can confirm that text is yanked correctly and see yanked text by highlighting.

:heavy_check_mark: Dependency :heavy_check_mark:
------------------------------------------------

This plugin depends on [kana/vim-operator-user](https://github.com/kana/vim-operator-user). Please install it in advance.

:package: Installation :package:
--------------------------------

Install with your favorite plugin managers like [Neobundle](https://github.com/Shougo/neobundle.vim) / [Vundle](https://github.com/gmarik/Vundle.vim) / [vim-plug](https://github.com/junegunn/vim-plug)

```vim
NeoBundle 'kana/vim-operator-user'
NeoBundle 'haya14busa/vim-operator-flashy'

Plugin 'kana/vim-operator-user'
Plugin 'haya14busa/vim-operator-flashy'

Plug 'kana/vim-operator-user'
Plug 'haya14busa/vim-operator-flashy'
```

[pathogen](https://github.com/tpope/vim-pathogen)

```
git clone https://github.com/kana/vim-operator-user ~/.vim/bundle/vim-operator-user
git clone https://github.com/haya14busa/vim-operator-flashy ~/.vim/bundle/vim-operator-flashy
```

:tada: Usage :tada:
-------------------

```vim
map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$
```

:bird: Author :bird:
--------------------
haya14busa (https://github.com/haya14busa)

:orange_book: Documentation :orange_book:
-----------------------------------------

[**:h operator-flashy.txt**](./doc/operator-flashy.txt)

Vim configuration for z80 coding.
=================================

This repository contains personal and public piece of code.

I do not really remember where I have found the syntax file.

It is adapted to match sjasmplus and vasm, other assemblers should work but some directives may have different names.

The aim of this repository is to provide z80 configuration in order to ease
my development for the Amstrad CPC.

So, syntax highligting, functions and so on can not be of interest in context
different than Amstrad CPC democoding, or even for other people than me.

Anyway, it is public and can be interesting for other people.

Installation
============

Manual installation
~~~~~~~~~~~~~~~~~~~

Copy the ftdetect, ftplugin and syntax directories in your .vim directory (~/.vim on Linux)


Automated installation with vim-plug
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Plug 'cpcsdk/vim-z80-democoding'`


Usage
=====

All .src, .asm and .z80 files are automatically detected by the ftdetect file, and the syntax is applied.

There are some functions to easily migrate code from sjasmplus to vasm (which I recommend using, it is a great assembler).

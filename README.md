# cc65-customizing-demo

Contains the result of following the `cc65` project's [tutorial](https://cc65.github.io/doc/customizing.html) for defining a custom `cc65` target and building a "Hello World!" program for it.

## Devlog

- On WSL: `cp /usr/share/cc65/lib/supervision.lib sbc.lib`
- In `sbc.cfg`'s `SYMBOLS` section, the tutorial says to use `weak = yes`, but [this should likely be `type = weak`](http://forum.6502.org/viewtopic.php?t=5254)
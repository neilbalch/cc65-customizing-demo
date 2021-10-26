# Devlog

- On WSL: `cp /usr/share/cc65/lib/supervision.lib sbc.lib`
- In `sbc.cfg`'s `SYMBOLS` section, the tutorial says to use `weak = yes`, but [this should likely be `type = weak`](http://forum.6502.org/viewtopic.php?t=5254)
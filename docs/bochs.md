# Debug command
```sh
b address     # breakpoint
c             # continue
s             # step  single
info cpu      # show registers info
r             # show registers info
sreg          # show section registers info
creg          # show control registers info
xp /nuf addr  # show content of the physical memory address
x  /nuf addr  # show content of the virtual  memory address
u start end   # disassembly start from `start` and end to `end`

# n is number
# u is size(b: byte, h: word, w: dword, g: qword)
# f is format(x: hex, d: decimal, t: binary, c: char)

# example
xp /10bx 0x100000
```

# Problems when using bochs

```
Problem: cpu directive malformed?
Slove:   run `bochs --help cpu` to detect supported CPUs, then reinstall 
         new bochs that support the cpu(corei7_ivy_bridge_3770k) or 
         modified cpu items in bochs.conf 
```


```
Problem: bochs x11 window is black screen
Slove:   don't worry, because you just entered debug mode, and press 'c' to 
         continue
```
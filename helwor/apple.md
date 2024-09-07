# Programming Assembly on MacOS

## Important Distinctions

__Apple's Operating System is simply a flavor of the [Darwin](https://en.wikipedia.org/wiki/Darwin_(operating_system)) operating system that shares a common set of components with Linux__

Linux and Darwin, which were both inspired by [AT&T Unix System V](https://unix.org/what_is_unix/history_timeline.html), are significantly different at the level we are looking at. For the listings in the book, this mostly concerns system calls (i.e. when we want the Kernel to do someting for us), and the way Darwin accesses memory.

__GCC Compiler does not work on MacOS. MacOS functionality is deprecated. Although there is a `gcc` command in MacOS, it simply calls the Clang C-Compiler__

__The above also goes for the `as` command. The GNU `as` assembler is not available and although the command exists on MacOS, it calls the LLVM Clang assembler by default.__

System calls in Linux and macOS have several differences due to the unique conventions of each system.

### CPU Registers

Apple has made certain platform specific choices for the registers:
- Apple reserves X18 for its own use. Do not use this register.
- The frame pointer register (FP, X29) must always address a valid frame record.

> **Caution:**  
> Darwin function numbers are considered private by Apple and are subject to change. They are provided here for educational purposes only.


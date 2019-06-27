# xv6-editor
___NOTICE: My xv6 is ran in QEMU simulator.___

The folder _xv6_all_files_ contains all the original code and all the executable file of xv6-rev7(release version 7) system.

_editor.c_ file contains the main code of my simple editor.

The simple editor can simply highlight the _C_ language. Its effect is demostrated below.

![code highlight demo](https://github.com/TamgMoon/xv6-editor/demo/demo_highlight.PNG "code highlight")

This editor can mostly undo 20 steps sequently. It depends on the variable _MAX_ROLLBACK_STEP_. If you want more undo step, just extend this variable. There is a small bug with _undo delete command_. Unfortunately, it still has not been resolved though I have paid a lot of time in it. I suspect that I triggered a unfound system bug. Who knows? But don't worry about that. This small bug just limit our ability to undo the delete operation and I have forbidden this function. The other function wouldn't be affected. So you can use this editor safely. I have mark the code which with bug in the _editor.c_. 

Furthermore, press __help__ instruction for more oprating detail. All the operation are here.

![help info](https://github.com/TangMoon/xv6-editor/demo/demo_help.PNG "help info")


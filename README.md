# xv6-editor
___NOTICE: My xv6 is ran in QEMU simulator.___

The folder _**xv6_all_files**_ contains all the original code and all the executable file of xv6-rev7(release version 7) system.

_**editor.c**_ file contains the main code of my simple editor.

The simple editor can simply highlight the _C_ language. Its effect is demostrated below.

![code highlight demo](https://github.com/TangMoon/xv6-editor/raw/master/demo/demo_highlight.PNG "code highlight")

This editor can mostly undo 20 steps sequently. It depends on the variable _**MAX_ROLLBACK_STEP**_. If you want more undo step, just extend this variable. There is a small bug with _undo delete command_. Unfortunately, it still has not been resolved though I have paid a lot of time on it. I suspect that I triggered a unfound system bug. Who knows? But don't worry about that. This small bug just limit our ability to undo the delete operation and I have forbidden this function. The other function wouldn't be affected. So you can use this editor safely. I have mark the code which with bug in the _editor.c_. 

Furthermore, press __help__ instruction for more oprating detail. All the operations are here.

![help info](https://github.com/TangMoon/xv6-editor/raw/master/demo/demo_help.PNG "help info")

<br>

  
How to install xv6?
====
### _Execute the following instructions sequently._
#### 1. Install the gdb and gcc.
  ```C
  sudo apt-get install -y build-essential gdb 
  ```
  ```C
  sudo apt-get install gcc-multilib
  ```
#### 2. Install QEMU simulator.
  ```C
  sudo apt-get install qemu
  ```
#### 3. Clone origin xv6 code from github.
  ```C
  git clone git://github.com/mit-pdos/xv6-public.git
  ```
#### 4. Rollback to rev7 version.
Rev7 version is more stable and reliable.
  ```C
  cd xv6-public-master
  ```
  ```C
  git checkout -b xv6-rev7 xv6-rev7
  ```
#### 5. Open the _Makefile_ file, find the following line and complete it.
  ```C
  QEMU = qemu-system-x86_64
  ```
#### 6. Now you can compile xv6 system.
  ```C
  make
  ```
#### 7. If you see the following image, Congratulations! you have successfully compiled it.
  ![successfully compiled info]()
#### 8. Now you can open _xv6_ and enjoy it.
  ```C
  make qemu-nox
  ```

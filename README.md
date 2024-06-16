# Assignment 1: Primitive Mouse Support in xv6
### Goal
- The main goal of this assignment is to modify the xv6 starter code so as to handle inputs from an external device
- We had to add support for mouse or trackpad

### Idea Overview
- Refer mouse.c for most of the changes made, for the complete understanding of the code flow you need to start with the test cases and track how it is
- We were interacting with PS/2 controller which has two IO ports
- We were supposed to implement the following functions:
  - void mousewait_send(void): This was fairly simple as we had to poll untill the controller is ready to send us a packet
  - void mousewait_rev(void): This was easy as well as we had to poll untill the mouse controller had data ready for us to receive
  - void mousecmd(uchar cmd): This involved sending the required command to the data port and receiving and checking the acknowledgment for the same, called during mouse initialization
  - void mouseinit(void): This followed a series of events (mentioned clearly in lab1.md), sent appropriate message signals to the control port to enable mouse, set interrupt bits, select default settings and activating and start sending interrupt message by calling mousecmd and finally enabling mouse interrupts on CPU 0
  - void mouseintr(void): It reads three bytes at a time where only the first byte is of use, it uses the first byte to get to know what mouse command has been called, and finally drain the controller's buffer
- All of these steps are very clearly stated in the lab1.md file

This wa an easy assignment as we had enough code to draw analogy from and the lab1.md file was of great help as it explained every step in detail and explained it thoroughly.

Let me know if you have any doubts in the code :)
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "mouse.h"
#include "traps.h"

// Wait until the mouse controller is ready for us to send a packet
void 
mousewait_send(void) 
{
    while ((inb(0x64) & 0x02) != 0);
    return;
}

// Wait until the mouse controller has data for us to receive
void 
mousewait_recv(void) 
{
    while ((inb(0x64) & 0x01) == 0);
    return;
}

// Send a one-byte command to the mouse controller, and wait for it
// to be properly acknowledged
void 
mousecmd(uchar cmd) 
{
    mousewait_send();
    outb(0x64, 0xD4); // Send 0xD4 to control port to address the mouse
    mousewait_send();
    outb(0x60, cmd);  // Send the command to the data port
    mousewait_recv();
    uchar ack = inb(0x60); // Read the acknowledgement from the data port
    if (ack != 0xFA)
        panic("Mouse command not acknowledged");
    return;
}

void
mouseinit(void)
{
    mousewait_send();// Step 1: Wait until the controller can receive a control packet
    outb(0x64, 0xA8);// Step 2: Send 0xA8 to the control port to enable the mouse
    mousewait_send();// Step 3: Modify the "Compaq Status Byte" for mouse interrupts
    outb(0x64, 0x20); // Select Compaq Status byte
    mousewait_recv();
    uchar status = inb(0x60); // Read the status byte
    status |= 0x02; // Set the 2nd bit to 1 for interrupts
    mousewait_send();
    outb(0x64, 0x60); // Tell the controller about the modified status byte
    mousewait_send();
    outb(0x60, status); // Send the modified status byte
    mousecmd(0xF6);// Step 4: Use mousecmd function to send 0xF6 to select "default settings"
    mousecmd(0xF4);// Step 5: Use mousecmd function to send 0xF4 to activate and start sending interrupts
    ioapicenable(IRQ_MOUSE, 0);// Step 6: Enable mouse interrupt (IRQ12) on CPU 0 using ioapicenable
    cprintf("Mouse has been initialized");
    return;
}

void
mouseintr(void)
{
    // Read 3 bytes from the PS/2 controller buffer
    uchar status;
    uchar data[3];
    mousewait_recv();
    status = inb(0x64);
    if ((status & 0x01) == 0)
        return;
    data[0] = inb(0x60);
    data[1] = inb(0x60);
    data[2] = inb(0x60);
    if ((data[0] & (1 << 0)) || (data[0] & (1 << 1)) || (data[0] & (1 << 2)))
    {
        if (data[0] & (1 << 0))
            cprintf("LEFT\n");
        if (data[0] & (1 << 1))
            cprintf("RIGHT\n");
        if (data[0] & (1 << 2))
            cprintf("MID\n");
    }
    // Drain the controller's buffer
    while ((inb(0x64) & 0x01) != 0)
        inb(0x60);
    return;
}
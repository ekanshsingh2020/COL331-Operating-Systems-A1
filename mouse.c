#include "types.h"
#include "defs.h"
#include "x86.h"
#include "mouse.h"
#include "traps.h"

// Wait until the mouse controller is ready for us to send a packet
void 
mousewait_send(void) 
{
    while ((inb(MSSTATP) & 0x02) != 0);
    return;
}

// Wait until the mouse controller has data for us to receive
void 
mousewait_recv(void) 
{
    while ((inb(MSSTATP) & 0x01) == 0);
    return;
}

// Send a one-byte command to the mouse controller, and wait for it
// to be properly acknowledged
void 
mousecmd(uchar cmd) 
{
    mousewait_send();
    outb(MSSTATP, PS2MS); // send 0xD4 to control port to address the mouse
    mousewait_send();
    outb(MSDATAP, cmd);  // send the command to the data port
    mousewait_recv();
    uchar ack = inb(MSDATAP); // read the acknowledgement from the data port
    if (ack != MSACK)
        panic("Mouse command not acknowledged");
    return;
}

void
mouseinit(void)
{
    mousewait_send();// Step 1: Wait until the controller can receive a control packet
    outb(MSSTATP, MSEN);// Step 2: Send 0xA8 to the control port to enable the mouse
    mousewait_send();// Step 3: Modify the "Compaq Status Byte" for mouse interrupts
    outb(MSSTATP, 0x20); // Select Compaq Status byte
    mousewait_recv();
    uchar status = inb(MSDATAP); // Read the status byte
    status |= 0x02; // Set the 2nd bit to 1 for interrupts
    mousewait_send();
    outb(MSSTATP, MSDATAP); // Tell the controller about the modified status byte
    mousewait_send();
    outb(MSDATAP, status); // Send the modified status byte
    mousecmd(0xF6);// Step 4: Use mousecmd function to send 0xF6 to select "default settings"
    mousecmd(0xF4);// Step 5: Use mousecmd function to send 0xF4 to activate and start sending interrupts
    ioapicenable(IRQ_MOUSE, 0);// Step 6: Enable mouse interrupt (IRQ12) on CPU 0 using ioapicenable
    cprintf("Mouse has been initialized");
    return;
}

void
mouseintr(void)
{
    // read 3 bytes from the PS/2 controller buffer
    mousewait_recv();
    uchar status = inb(MSSTATP);
    if ((status & 0x01) == 0)
        return;
    uchar data[3];
    data[0] = inb(MSDATAP);
    data[1] = inb(MSDATAP);
    data[2] = inb(MSDATAP);
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
    while ((inb(MSSTATP) & 0x01) != 0)
        inb(MSDATAP);
    return;
}
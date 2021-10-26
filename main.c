// Create (readable/writable) macros to the memory locations of the hypothetical
// RS232 buffer and its status byte.
#define FIFO_DATA (*(unsigned char *)0x1000)  // Reading pops a byte off the RX
                                              // FIFO buffer, writing pushes a
                                              // byte into the TX FIFO buffer.
#define FIFO_STATUS (*(unsigned char *)0x1001)

// Create macros for masking out the RS232 buffer status byte's bits for
// signalling the presence of unread/received bytes.
#define TX_FIFO_FULL (FIFO_STATUS & 0x01)
#define RX_FIFO_EMPTY (FIFO_STATUS & 0x02)

extern void wait();
// __fastcall__ (default for functions *not* specifying __cdecl__) instructs
// cc65 to (for non-variadic functions) pass the rightmost function argument
// using the 6502's registers instead of by the stack. (faster/more efficient)
// Needs to be used here because the rs232_tx implementation doesn't pull from
// the stack.
//
// __cdecl__ would instruct parameters to be passed through the stack. (slower)
// (See https://cc65.github.io/doc/customizing.html#s7 for more details.)
extern void __fastcall__ rs232_tx(char *str);

int main() {
  while (1) {  //  Run forever
    wait();    //  Wait for an RX FIFO interrupt

    while (RX_FIFO_EMPTY == 0) {   //  While the RX FIFO is not empty
      if (FIFO_DATA == '?') {      //  Dmes the RX character = '?'
        rs232_tx("Hello World!");  //  Transmit "Hello World!"
      }                            //  Discard any other RX characters
    }
  }

  return 0;  //  We should never get here!
}
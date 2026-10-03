

void kernel_main(void) {
    char *video_memory = (char *)0xb8000;
    video_memory[0] = 'H';
    video_memory[1] = 0x07; // White text on black background

    while (1) {
        // Infinite loop to keep the kernel running
    }
}
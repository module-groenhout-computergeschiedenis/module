#include <cx16-kernal.h>
#include <string.h>




/**
 * @brief Read a number of bytes from the sdcard using kernal macptr call.
 * BRAM bank needs to be set properly before the load between adressed A000 and BFFF.
 * 
 * @return x the size of bytes read
 * @return y the size of bytes read
 * @return if carry is set there is an error
 */
unsigned int cbm_k_macptr(unsigned char bytes, void* buffer) 
{
    __mem unsigned int bytes_read;
    asm {
        lda bytes
        ldx buffer
        ldy buffer+1

        clc  // needed from R42 of the CX16 commander rom to ensure MACPTR is progressing the read address.
        // .byte $db
        jsr CBM_MACPTR
        stx bytes_read
        sty bytes_read+1
        bcc !+
        lda #$FF
        sta bytes_read
        sta bytes_read+1
        !:
    }
    return bytes_read;
}



/**
 * @brief Load into RAM from a device.
 * 
 * @param address Target address in RAM.
 * @param verify 
 * @return char Status
 */
unsigned char cbm_k_load(char* address, char verify) 
{
    __mem unsigned char status;
    asm {
        //LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
        // Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
        // Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).
        ldx address
        ldy address+1
        lda verify
        jsr $ffd5
        bcs error
        lda #$ff
        error:
        sta status
    }
    return status;
}


/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
unsigned int cbm_k_plot_get() 
{
    __mem unsigned char x;
    __mem unsigned char y;
    kickasm(uses x, uses y, uses CBM_PLOT) {{
        sec
        jsr CBM_PLOT
        stx y
        sty x
    }}
    return MAKEWORD(x,y);
}

/**
 * @brief Set current cursor position using x and y coordinates.
 * 
 */
void cbm_k_plot_set(unsigned char x, unsigned char y)
{
    kickasm(uses x, uses y, uses CBM_PLOT) {{
        ldx y
        ldy x
        clc
        jsr CBM_PLOT
    }}
}



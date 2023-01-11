/**
 * @brief Standard cbm kernal calls.
 * 
 */


/**
 * @brief Get a character from the input channel.
 * 
 * @return char 
 */
unsigned char cbm_k_chrin() 
{
    unsigned char value;
    asm {
        jsr CBM_CHRIN
        sta value
    }
    return value;
}


/**
 * @brief Scan a character from keyboard without pressing enter.
 * 
 * @return char The character read.
 */
unsigned char cbm_k_getin() 
{
    __mem unsigned char ch;
    asm {
        jsr CBM_GETIN
        sta ch
    }
    return ch;
}

/**
 * @brief Sets the logical file channel.
 * 
 * @param channel the logical file number.
 * @param device the device number.
 * @param command the command.
 */
void cbm_k_setlfs(char channel, char device, char command) 
{
    asm {
        ldx device
        lda channel
        ldy command
        jsr CBM_SETLFS
    }
}

/**
 * @brief Sets the name of the file before opening.
 * 
 * @param filename The name of the file.
 */
void cbm_k_setnam(char* filename) 
{
    __mem char filename_len = (char)strlen(filename);
    asm {
        lda filename_len
        ldx filename
        ldy filename+1
        jsr CBM_SETNAM
    }
}

/**
 * @brief Open a logical file.
 * 
 * @return char The status.
 */
unsigned char cbm_k_open() 
{
    __mem unsigned char status;
    asm {
        //.byte $db
        jsr CBM_OPEN
        sta status
    }
    return status;
}

/**
 * @brief Close a logical file.
 * 
 * @param channel The channel to close.
 * @return char Status.
 */
unsigned char cbm_k_close(char channel) 
{
    __mem unsigned char status;
    asm {
      //   .byte $db
        lda channel
        jsr CBM_CLOSE
        sta status
    }
    return status;
}


/**
 * @brief Open a channel for input.
 * 
 * @param channel 
 * @return char 
 */
unsigned char cbm_k_chkin(char channel)
{
    __mem unsigned char status;
    asm {
        ldx channel
        jsr CBM_CHKIN
        sta status
    }
    return status;
}


/**
 * @brief Clear all I/O channels.
 * 
 */
void cbm_k_clrchn() {
    asm {
        jsr CBM_CLRCHN
    }
}

/**
 * @brief Read the status of the I/O.
 * 
 * @return char Status.
 */
unsigned char cbm_k_readst() 
{
    __mem unsigned char status;
    asm {
        //.byte $db
        jsr CBM_READST
        sta status
    }
    return status;
}

/**
 * @brief Output a character to the defined channel.
 * 
 */
void cbm_k_chrout(char c) 
{
    asm {
        lda c
        jsr CBM_CHROUT
    }
}


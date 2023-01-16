/**
 * @brief CBM kernal calls and kernal registry currently modelled in kickc. 
 * 
 */

// Common CBM Kernal Routines

const unsigned int CBM_SETNAM = 0xFFBD; ///< Set the name of a file.
const unsigned int CBM_SETLFS = 0xFFBA; ///< Set the logical file.
const unsigned int CBM_OPEN   = 0xFFC0; ///< Open the file for the current logical file.
const unsigned int CBM_CHKIN  = 0xFFC6; ///< Set the logical channel for input.
const unsigned int CBM_READST = 0xFFB7; ///< Check I/O errors.
const unsigned int CBM_CHRIN  = 0xFFCF; ///< Read a character from the current channel for input.
const unsigned int CBM_CLOSE  = 0xFFC3; ///< Close a logical file.
const unsigned int CBM_CLRCHN = 0xFFCC; ///< Close all logical files.
const unsigned int CBM_GETIN  = 0xFFE4; ///< Scan a character from the keyboard.
const unsigned int CBM_CHROUT = 0xFFD2; ///< Output a character.

/* inline */ unsigned char cbm_k_chrin();
/* inline */ unsigned char cbm_k_getin();
/* inline */ void cbm_k_setlfs(char channel, char device, char command);
/* inline */ void cbm_k_setnam(char* filename);
/* inline */ unsigned char cbm_k_open();
/* inline */ unsigned char cbm_k_close(char channel);
/* inline */ unsigned char cbm_k_chkin(char channel);
/* inline */ unsigned char cbm_k_readst();
/* inline */ void cbm_k_chrout(char c);




#if defined(__CX16__)
#include "cx16-kernal.h"
#elif defined(__PET8032__)
#include "pet-kernal.h"
#elif defined(__C64__)
#include "c64-kernal.h"
#elif defined(__C128__)
#include "c64-kernal.h"
#else
#error "Target platform does not support kernal.h"
#endif

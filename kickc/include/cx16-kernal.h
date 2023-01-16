/**
 * @file cx16-kernal.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief CX16 Kernal Wrapper
 * @version 0.1
 * @date 2022-01-29
 * 
 * @copyright Copyright (c) 2022
 * 
 */

const unsigned int CBM_LOAD   = 0xFFD5; ///< Load a logical file.
const unsigned int CBM_PLOT   = 0xFFF0; ///< Set or get current cursor location.
const unsigned int CBM_MACPTR = 0xFF44; ///< CX16 Faster loading from SDCARD.


/* inline */ unsigned int cbm_k_macptr(unsigned char bytes, void* buffer); 
/* inline */ unsigned char cbm_k_load(char* address, char verify);
/* inline */ unsigned int cbm_k_plot_get();
/* inline */ void cbm_k_plot_set(unsigned char x, unsigned char y);

const unsigned int CBM_LOAD   = 0xFFD5; ///< Load a logical file.
const unsigned int CBM_PLOT   = 0xFFF0; ///< Set or get current cursor location.
const unsigned int CBM_MACPTR = 0xFF44; ///< CX16 Faster loading from SDCARD.


/* inline */ unsigned int cbm_k_macptr(unsigned char bytes, void* buffer); 
/* inline */ unsigned char cbm_k_load(char* address, char verify);
/* inline */ unsigned int cbm_k_plot_get();
/* inline */ void cbm_k_plot_set(unsigned char x, unsigned char y);







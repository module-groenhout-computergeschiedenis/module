/// @file

const unsigned int CBM_LOAD   = 0xFFD5; ///< Load a logical file.
const unsigned int CBM_PLOT   = 0xFFF0; ///< Set or get current cursor location.
const unsigned int CBM_MACPTR = 0xFF44; ///< CX16 Faster loading from SDCARD.


/* inline */ unsigned int cbm_k_macptr(unsigned char bytes, void* buffer); 
/* inline */ unsigned char cbm_k_load(char* address, char verify);
/* inline */ unsigned int cbm_k_plot_get();
/* inline */ void cbm_k_plot_set(unsigned char x, unsigned char y);



/// Kernal SETNAM function
/// SETNAM. Set file name parameters.
void setnam(char* filename);

/// SETLFS. Set file parameters.
void setlfs(char device);

/// LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
/// - verify: 0 = Load, 1-255 = Verify
/// Returns a status, 0xff: Success other: Kernal Error Code
char load(char* address, char verify);

/// GETIN. Read a byte from the input channel
/// return: next byte in buffer or 0 if buffer is empty.
char getin();

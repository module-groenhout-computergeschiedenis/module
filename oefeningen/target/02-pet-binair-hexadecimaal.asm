  // File Comments
/**
 * @file 01-pet-binair-hexadecimaal.c
 * @author your name (you@domain.com)
 * @brief Je bent op weg naar je eerste C programma, dat werkt op de PET 8032!
 * Hier leer je hoe de printf functie gebruikt in C (de basis).
 * Je leert wat binaire, octale en hexadecimale talstelsels zijn, 
 * en waarom ze belangrijk zijn in de computerwereld. We zullen dit toelichten in de klas.
 * Je leert ook hoe je zelf functies can maken in je eigen programma in de C-taal.
 * We bekijken samen hoe een C programma in machinetaal is uitgedrukt.
 * We leren de basis instructieset van de 6502 processor. 
 * @version 0.1
 * @date 2022-12-15
 *
 * @copyright Copyright (c) 2022
 *
 */
  // Upstart
  // Commodore PET 8032 PRG executable file
.file [name="02-pet-binair-hexadecimaal.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0401]
.segmentdef Code [start=$40d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // Global Constants & labels
  .const BINARY = 2
  .const OCTAL = 8
  .const DECIMAL = $a
  .const HEXADECIMAL = $10
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $8000
  // The number of bytes on the screen
  // The current cursor x-position
  .label conio_cursor_x = $22
  // The current cursor y-position
  .label conio_cursor_y = $23
  // The current text cursor line start
  .label conio_line_text = $24
  /// The capacity of the buffer (n passed to snprintf())
  /// Used to hold state while printing
  .label __snprintf_capacity = $20
  // The number of chars that would have been filled when printing without capacity. Grows even after size>capacity.
  /// Used to hold state while printing
  .label __snprintf_size = $1c
  /// Current position in the buffer being filled ( initially *s passed to snprintf()
  /// Used to hold state while printing
  .label __snprintf_buffer = $1e
.segment Code
  // __start
__start: {
    // __start::__init1
    // __ma char conio_cursor_x = 0
    // [1] conio_cursor_x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_cursor_x
    // __ma char conio_cursor_y = 0
    // [2] conio_cursor_y = 0 -- vbuz1=vbuc1 
    sta.z conio_cursor_y
    // __ma char *conio_line_text = CONIO_SCREEN_TEXT
    // [3] conio_line_text = DEFAULT_SCREEN -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // volatile size_t __snprintf_capacity
    // [4] __snprintf_capacity = 0 -- vwuz1=vwuc1 
    lda #<0
    sta.z __snprintf_capacity
    sta.z __snprintf_capacity+1
    // volatile size_t __snprintf_size
    // [5] __snprintf_size = 0 -- vwuz1=vwuc1 
    sta.z __snprintf_size
    sta.z __snprintf_size+1
    // char * __snprintf_buffer
    // [6] __snprintf_buffer = (char *) 0 -- pbuz1=pbuc1 
    sta.z __snprintf_buffer
    sta.z __snprintf_buffer+1
    // [7] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [8] call main
    // [29] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [9] return 
    rts
}
  // snputc
/// Print a character into snprintf buffer
/// Used by snprintf()
/// @param c The character to print
// void snputc(__zp($1b) char c)
snputc: {
    .const OFFSET_STACK_C = 0
    .label c = $1b
    // [10] snputc::c#0 = stackidx(char,snputc::OFFSET_STACK_C) -- vbuz1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // ++__snprintf_size;
    // [11] __snprintf_size = ++ __snprintf_size -- vwuz1=_inc_vwuz1 
    inc.z __snprintf_size
    bne !+
    inc.z __snprintf_size+1
  !:
    // if(__snprintf_size > __snprintf_capacity)
    // [12] if(__snprintf_size<=__snprintf_capacity) goto snputc::@1 -- vwuz1_le_vwuz2_then_la1 
    lda.z __snprintf_size+1
    cmp.z __snprintf_capacity+1
    bne !+
    lda.z __snprintf_size
    cmp.z __snprintf_capacity
    beq __b1
  !:
    bcc __b1
    // snputc::@return
    // }
    // [13] return 
    rts
    // snputc::@1
  __b1:
    // if(__snprintf_size==__snprintf_capacity)
    // [14] if(__snprintf_size!=__snprintf_capacity) goto snputc::@3 -- vwuz1_neq_vwuz2_then_la1 
    lda.z __snprintf_size+1
    cmp.z __snprintf_capacity+1
    bne __b2
    lda.z __snprintf_size
    cmp.z __snprintf_capacity
    bne __b2
    // [16] phi from snputc::@1 to snputc::@2 [phi:snputc::@1->snputc::@2]
    // [16] phi snputc::c#2 = 0 [phi:snputc::@1->snputc::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // [15] phi from snputc::@1 to snputc::@3 [phi:snputc::@1->snputc::@3]
    // snputc::@3
    // [16] phi from snputc::@3 to snputc::@2 [phi:snputc::@3->snputc::@2]
    // [16] phi snputc::c#2 = snputc::c#0 [phi:snputc::@3->snputc::@2#0] -- register_copy 
    // snputc::@2
  __b2:
    // *(__snprintf_buffer++) = c
    // [17] *__snprintf_buffer = snputc::c#2 -- _deref_pbuz1=vbuz2 
    // Append char
    lda.z c
    ldy #0
    sta (__snprintf_buffer),y
    // *(__snprintf_buffer++) = c;
    // [18] __snprintf_buffer = ++ __snprintf_buffer -- pbuz1=_inc_pbuz1 
    inc.z __snprintf_buffer
    bne !+
    inc.z __snprintf_buffer+1
  !:
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($26) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label c = $26
    // [19] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuz1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // if(c=='\n')
    // [20] if(cputc::c#0==' 'pm) goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // conio_line_text[conio_cursor_x] = c
    // [21] conio_line_text[conio_cursor_x] = cputc::c#0 -- pbuz1_derefidx_vbuz2=vbuz3 
    lda.z c
    ldy.z conio_cursor_x
    sta (conio_line_text),y
    // if(++conio_cursor_x==CONIO_WIDTH)
    // [22] conio_cursor_x = ++ conio_cursor_x -- vbuz1=_inc_vbuz1 
    inc.z conio_cursor_x
    // [23] if(conio_cursor_x!=$50) goto cputc::@return -- vbuz1_neq_vbuc1_then_la1 
    lda #$50
    cmp.z conio_cursor_x
    bne __breturn
    // [24] phi from cputc::@2 to cputc::@3 [phi:cputc::@2->cputc::@3]
    // cputc::@3
    // cputln()
    // [25] call cputln
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [26] return 
    rts
    // [27] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [28] call cputln
    jsr cputln
    rts
}
  // main
/**
 * @brief De main functie van je pong game.
 *
 * @return int
 */
main: {
    // Dit wist het scherm :-)
    .label number = $a
    // clrscr()
    // [30] call clrscr
    // [53] phi from main to clrscr [phi:main->clrscr]
    jsr clrscr
    // [31] phi from main to main::@1 [phi:main->main::@1]
    // main::@1
    // binary(number)
    // [32] call binary
    // [66] phi from main::@1 to binary [phi:main::@1->binary]
    jsr binary
    // [33] phi from main::@1 to main::@2 [phi:main::@1->main::@2]
    // main::@2
    // hexadecimal(number)
    // [34] call hexadecimal
    // [77] phi from main::@2 to hexadecimal [phi:main::@2->hexadecimal]
    jsr hexadecimal
    // [35] phi from main::@2 to main::@3 [phi:main::@2->main::@3]
    // main::@3
    // printf("%u = %s, %s\n", number, binary(number), hexadecimal(number))
    // [36] call printf_uint
    // [87] phi from main::@3 to printf_uint [phi:main::@3->printf_uint]
    // [87] phi printf_uint::format_zero_padding#2 = 0 [phi:main::@3->printf_uint#0] -- vbuz1=vbuc1 
    lda #0
    sta.z printf_uint.format_zero_padding
    // [87] phi printf_uint::format_min_length#2 = 0 [phi:main::@3->printf_uint#1] -- vbuz1=vbuc1 
    sta.z printf_uint.format_min_length
    // [87] phi printf_uint::putc#2 = &cputc [phi:main::@3->printf_uint#2] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_uint.putc
    lda #>cputc
    sta.z printf_uint.putc+1
    // [87] phi printf_uint::format_radix#2 = DECIMAL [phi:main::@3->printf_uint#3] -- vbuz1=vbuc1 
    lda #DECIMAL
    sta.z printf_uint.format_radix
    jsr printf_uint
    // [37] phi from main::@3 to main::@4 [phi:main::@3->main::@4]
    // main::@4
    // printf("%u = %s, %s\n", number, binary(number), hexadecimal(number))
    // [38] call printf_str
    // [97] phi from main::@4 to printf_str [phi:main::@4->printf_str]
    // [97] phi printf_str::putc#8 = &cputc [phi:main::@4->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [97] phi printf_str::s#8 = main::s [phi:main::@4->printf_str#1] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [39] phi from main::@4 to main::@5 [phi:main::@4->main::@5]
    // main::@5
    // printf("%u = %s, %s\n", number, binary(number), hexadecimal(number))
    // [40] call printf_string
    // [106] phi from main::@5 to printf_string [phi:main::@5->printf_string]
    // [106] phi printf_string::str#2 = binary::bin [phi:main::@5->printf_string#0] -- pbuz1=pbuc1 
    lda #<binary.bin
    sta.z printf_string.str
    lda #>binary.bin
    sta.z printf_string.str+1
    jsr printf_string
    // [41] phi from main::@5 to main::@6 [phi:main::@5->main::@6]
    // main::@6
    // printf("%u = %s, %s\n", number, binary(number), hexadecimal(number))
    // [42] call printf_str
    // [97] phi from main::@6 to printf_str [phi:main::@6->printf_str]
    // [97] phi printf_str::putc#8 = &cputc [phi:main::@6->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [97] phi printf_str::s#8 = main::s1 [phi:main::@6->printf_str#1] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // [43] phi from main::@6 to main::@7 [phi:main::@6->main::@7]
    // main::@7
    // printf("%u = %s, %s\n", number, binary(number), hexadecimal(number))
    // [44] call printf_string
    // [106] phi from main::@7 to printf_string [phi:main::@7->printf_string]
    // [106] phi printf_string::str#2 = hexadecimal::hex [phi:main::@7->printf_string#0] -- pbuz1=pbuc1 
    lda #<hexadecimal.hex
    sta.z printf_string.str
    lda #>hexadecimal.hex
    sta.z printf_string.str+1
    jsr printf_string
    // [45] phi from main::@7 to main::@8 [phi:main::@7->main::@8]
    // main::@8
    // printf("%u = %s, %s\n", number, binary(number), hexadecimal(number))
    // [46] call printf_str
    // [97] phi from main::@8 to printf_str [phi:main::@8->printf_str]
    // [97] phi printf_str::putc#8 = &cputc [phi:main::@8->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [97] phi printf_str::s#8 = main::s2 [phi:main::@8->printf_str#1] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // main::@return
    // }
    // [47] return 
    rts
  .segment Data
    s: .text " = "
    .byte 0
    s1: .text ", "
    .byte 0
    s2: .text @"\n"
    .byte 0
}
.segment Code
  // cputln
// Print a newline
cputln: {
    // conio_line_text +=  CONIO_WIDTH
    // [48] conio_line_text = conio_line_text + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z conio_line_text
    sta.z conio_line_text
    bcc !+
    inc.z conio_line_text+1
  !:
    // conio_cursor_x = 0
    // [49] conio_cursor_x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y++;
    // [50] conio_cursor_y = ++ conio_cursor_y -- vbuz1=_inc_vbuz1 
    inc.z conio_cursor_y
    // cscroll()
    // [51] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [52] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label c = $16
    .label line_text = $11
    .label l = $19
    // [54] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [54] phi clrscr::line_text#5 = DEFAULT_SCREEN [phi:clrscr->clrscr::@1#0] -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z line_text
    lda #>DEFAULT_SCREEN
    sta.z line_text+1
    // [54] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [55] if(clrscr::l#2<$19) goto clrscr::@3 -- vbuz1_lt_vbuc1_then_la1 
    lda.z l
    cmp #$19
    bcc __b2
    // clrscr::@2
    // conio_cursor_x = 0
    // [56] conio_cursor_x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z conio_cursor_x
    // conio_cursor_y = 0
    // [57] conio_cursor_y = 0 -- vbuz1=vbuc1 
    sta.z conio_cursor_y
    // conio_line_text = CONIO_SCREEN_TEXT
    // [58] conio_line_text = DEFAULT_SCREEN -- pbuz1=pbuc1 
    lda #<DEFAULT_SCREEN
    sta.z conio_line_text
    lda #>DEFAULT_SCREEN
    sta.z conio_line_text+1
    // clrscr::@return
    // }
    // [59] return 
    rts
    // [60] phi from clrscr::@1 to clrscr::@3 [phi:clrscr::@1->clrscr::@3]
  __b2:
    // [60] phi clrscr::c#2 = 0 [phi:clrscr::@1->clrscr::@3#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@3
  __b3:
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [61] if(clrscr::c#2<$50) goto clrscr::@4 -- vbuz1_lt_vbuc1_then_la1 
    lda.z c
    cmp #$50
    bcc __b4
    // clrscr::@5
    // line_text += CONIO_WIDTH
    // [62] clrscr::line_text#1 = clrscr::line_text#5 + $50 -- pbuz1=pbuz1_plus_vbuc1 
    lda #$50
    clc
    adc.z line_text
    sta.z line_text
    bcc !+
    inc.z line_text+1
  !:
    // for( char l=0;l<CONIO_HEIGHT; l++ )
    // [63] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [54] phi from clrscr::@5 to clrscr::@1 [phi:clrscr::@5->clrscr::@1]
    // [54] phi clrscr::line_text#5 = clrscr::line_text#1 [phi:clrscr::@5->clrscr::@1#0] -- register_copy 
    // [54] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@5->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@4
  __b4:
    // line_text[c] = ' '
    // [64] clrscr::line_text#5[clrscr::c#2] = ' 'pm -- pbuz1_derefidx_vbuz2=vbuc1 
    lda #' '
    ldy.z c
    sta (line_text),y
    // for( char c=0;c<CONIO_WIDTH; c++ )
    // [65] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [60] phi from clrscr::@4 to clrscr::@3 [phi:clrscr::@4->clrscr::@3]
    // [60] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@4->clrscr::@3#0] -- register_copy 
    jmp __b3
}
  // binary
// char * binary(__zp($11) unsigned int number)
binary: {
    .label __1 = $1a
    .label number = $11
    .label b = $19
    // [67] phi from binary to binary::@1 [phi:binary->binary::@1]
    // [67] phi binary::number#2 = main::number [phi:binary->binary::@1#0] -- vwuz1=vwuc1 
    lda #<main.number
    sta.z number
    lda #>main.number
    sta.z number+1
    // [67] phi binary::b#2 = $11 [phi:binary->binary::@1#1] -- vbuz1=vbuc1 
    lda #$11
    sta.z b
    // binary::@1
  __b1:
    // for(char b=17; b>=2; b--)
    // [68] if(binary::b#2>=2) goto binary::@2 -- vbuz1_ge_vbuc1_then_la1 
    lda.z b
    cmp #2
    bcs __b2
    // binary::@3
    // *(bin+18) = '\0'
    // [69] *(binary::bin+$12) = '?'pm -- _deref_pbuc1=vbuc2 
    lda #'\$00'
    sta bin+$12
    // binary::@return
    // }
    // [70] return 
    rts
    // binary::@2
  __b2:
    // number & 0b1
    // [71] binary::$1 = binary::number#2 & 1 -- vbuz1=vwuz2_band_vbuc1 
    lda #1
    and.z number
    sta.z __1
    // if(number & 0b1)
    // [72] if(0!=binary::$1) goto binary::@4 -- 0_neq_vbuz1_then_la1 
    bne __b4
    // binary::@6
    // *(bin+b) = '0'
    // [73] binary::bin[binary::b#2] = '0'pm -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #'0'
    ldy.z b
    sta bin,y
    // binary::@5
  __b5:
    // number >>= 1
    // [74] binary::number#0 = binary::number#2 >> 1 -- vwuz1=vwuz1_ror_1 
    lsr.z number+1
    ror.z number
    // for(char b=17; b>=2; b--)
    // [75] binary::b#1 = -- binary::b#2 -- vbuz1=_dec_vbuz1 
    dec.z b
    // [67] phi from binary::@5 to binary::@1 [phi:binary::@5->binary::@1]
    // [67] phi binary::number#2 = binary::number#0 [phi:binary::@5->binary::@1#0] -- register_copy 
    // [67] phi binary::b#2 = binary::b#1 [phi:binary::@5->binary::@1#1] -- register_copy 
    jmp __b1
    // binary::@4
  __b4:
    // *(bin+b) = '1'
    // [76] binary::bin[binary::b#2] = '1'pm -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #'1'
    ldy.z b
    sta bin,y
    jmp __b5
  .segment Data
    bin: .text "0b"
    .byte 0
    .fill $10, 0
}
.segment Code
  // hexadecimal
// char * hexadecimal(unsigned int number)
hexadecimal: {
    // sprintf(hex, "0x%04x", number)
    // [78] call snprintf_init
    jsr snprintf_init
    // [79] phi from hexadecimal to hexadecimal::@1 [phi:hexadecimal->hexadecimal::@1]
    // hexadecimal::@1
    // sprintf(hex, "0x%04x", number)
    // [80] call printf_str
    // [97] phi from hexadecimal::@1 to printf_str [phi:hexadecimal::@1->printf_str]
    // [97] phi printf_str::putc#8 = &snputc [phi:hexadecimal::@1->printf_str#0] -- pprz1=pprc1 
    lda #<snputc
    sta.z printf_str.putc
    lda #>snputc
    sta.z printf_str.putc+1
    // [97] phi printf_str::s#8 = hexadecimal::s [phi:hexadecimal::@1->printf_str#1] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [81] phi from hexadecimal::@1 to hexadecimal::@2 [phi:hexadecimal::@1->hexadecimal::@2]
    // hexadecimal::@2
    // sprintf(hex, "0x%04x", number)
    // [82] call printf_uint
    // [87] phi from hexadecimal::@2 to printf_uint [phi:hexadecimal::@2->printf_uint]
    // [87] phi printf_uint::format_zero_padding#2 = 1 [phi:hexadecimal::@2->printf_uint#0] -- vbuz1=vbuc1 
    lda #1
    sta.z printf_uint.format_zero_padding
    // [87] phi printf_uint::format_min_length#2 = 4 [phi:hexadecimal::@2->printf_uint#1] -- vbuz1=vbuc1 
    lda #4
    sta.z printf_uint.format_min_length
    // [87] phi printf_uint::putc#2 = &snputc [phi:hexadecimal::@2->printf_uint#2] -- pprz1=pprc1 
    lda #<snputc
    sta.z printf_uint.putc
    lda #>snputc
    sta.z printf_uint.putc+1
    // [87] phi printf_uint::format_radix#2 = HEXADECIMAL [phi:hexadecimal::@2->printf_uint#3] -- vbuz1=vbuc1 
    lda #HEXADECIMAL
    sta.z printf_uint.format_radix
    jsr printf_uint
    // hexadecimal::@3
    // sprintf(hex, "0x%04x", number)
    // [83] stackpush(char) = 0 -- _stackpushbyte_=vbuc1 
    lda #0
    pha
    // [84] callexecute snputc  -- call_vprc1 
    jsr snputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // hexadecimal::@return
    // }
    // [86] return 
    rts
  .segment Data
    hex: .fill 7, 0
    s: .text "0x"
    .byte 0
}
.segment Code
  // printf_uint
// Print an unsigned int using a specific format
// void printf_uint(__zp($11) void (*putc)(char), unsigned int uvalue, __zp($1a) char format_min_length, char format_justify_left, char format_sign_always, __zp($19) char format_zero_padding, char format_upper_case, __zp($16) char format_radix)
printf_uint: {
    .label format_radix = $16
    .label putc = $11
    .label format_min_length = $1a
    .label format_zero_padding = $19
    // printf_uint::@1
    // printf_buffer.sign = format.sign_always?'+':0
    // [88] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // utoa(uvalue, printf_buffer.digits, format.radix)
    // [89] utoa::radix#0 = printf_uint::format_radix#2
    // [90] call utoa
    // Format number into buffer
    jsr utoa
    // printf_uint::@2
    // printf_number_buffer(putc, printf_buffer, format)
    // [91] printf_number_buffer::putc#0 = printf_uint::putc#2
    // [92] printf_number_buffer::buffer_sign#0 = *((char *)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [93] printf_number_buffer::format_min_length#0 = printf_uint::format_min_length#2
    // [94] printf_number_buffer::format_zero_padding#0 = printf_uint::format_zero_padding#2
    // [95] call printf_number_buffer
    // Print using format
    jsr printf_number_buffer
    // printf_uint::@return
    // }
    // [96] return 
    rts
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(__zp($11) void (*putc)(char), __zp(7) const char *s)
printf_str: {
    .label c = 4
    .label s = 7
    .label putc = $11
    // [98] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [98] phi printf_str::s#7 = printf_str::s#8 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [99] printf_str::c#1 = *printf_str::s#7 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [100] printf_str::s#0 = ++ printf_str::s#7 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [101] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // printf_str::@return
    // }
    // [102] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [103] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuz1 
    lda.z c
    pha
    // [104] callexecute *printf_str::putc#8  -- call__deref_pprz1 
    jsr icall2
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
    // Outside Flow
  icall2:
    jmp (putc)
}
  // printf_string
// Print a string value using a specific format
// Handles justification and min length 
// void printf_string(void (*putc)(char), __zp(7) char *str, char format_min_length, char format_justify_left)
printf_string: {
    .label str = 7
    // printf_string::@1
    // printf_str(putc, str)
    // [107] printf_str::s#2 = printf_string::str#2
    // [108] call printf_str
    // [97] phi from printf_string::@1 to printf_str [phi:printf_string::@1->printf_str]
    // [97] phi printf_str::putc#8 = &cputc [phi:printf_string::@1->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [97] phi printf_str::s#8 = printf_str::s#2 [phi:printf_string::@1->printf_str#1] -- register_copy 
    jsr printf_str
    // printf_string::@return
    // }
    // [109] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(conio_cursor_y==CONIO_HEIGHT)
    // [110] if(conio_cursor_y!=$19) goto cscroll::@return -- vbuz1_neq_vbuc1_then_la1 
    lda #$19
    cmp.z conio_cursor_y
    bne __breturn
    // [111] phi from cscroll to cscroll::@1 [phi:cscroll->cscroll::@1]
    // cscroll::@1
    // memcpy(CONIO_SCREEN_TEXT, CONIO_SCREEN_TEXT+CONIO_WIDTH, CONIO_BYTES-CONIO_WIDTH)
    // [112] call memcpy
    // [182] phi from cscroll::@1 to memcpy [phi:cscroll::@1->memcpy]
    jsr memcpy
    // [113] phi from cscroll::@1 to cscroll::@2 [phi:cscroll::@1->cscroll::@2]
    // cscroll::@2
    // memset(CONIO_SCREEN_TEXT+CONIO_BYTES-CONIO_WIDTH, ' ', CONIO_WIDTH)
    // [114] call memset
    // [189] phi from cscroll::@2 to memset [phi:cscroll::@2->memset]
    jsr memset
    // cscroll::@3
    // conio_line_text -= CONIO_WIDTH
    // [115] conio_line_text = conio_line_text - $50 -- pbuz1=pbuz1_minus_vbuc1 
    sec
    lda.z conio_line_text
    sbc #$50
    sta.z conio_line_text
    lda.z conio_line_text+1
    sbc #0
    sta.z conio_line_text+1
    // conio_cursor_y--;
    // [116] conio_cursor_y = -- conio_cursor_y -- vbuz1=_dec_vbuz1 
    dec.z conio_cursor_y
    // cscroll::@return
  __breturn:
    // }
    // [117] return 
    rts
}
  // snprintf_init
/// Initialize the snprintf() state
// void snprintf_init(char *s, unsigned int n)
snprintf_init: {
    .const n = $ffff
    // __snprintf_capacity = n
    // [118] __snprintf_capacity = snprintf_init::n#0 -- vwuz1=vwuc1 
    lda #<n
    sta.z __snprintf_capacity
    lda #>n
    sta.z __snprintf_capacity+1
    // __snprintf_size = 0
    // [119] __snprintf_size = 0 -- vwuz1=vbuc1 
    lda #<0
    sta.z __snprintf_size
    sta.z __snprintf_size+1
    // __snprintf_buffer = s
    // [120] __snprintf_buffer = hexadecimal::hex -- pbuz1=pbuc1 
    lda #<hexadecimal.hex
    sta.z __snprintf_buffer
    lda #>hexadecimal.hex
    sta.z __snprintf_buffer+1
    // snprintf_init::@return
    // }
    // [121] return 
    rts
}
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp(2) unsigned int value, __zp(9) char *buffer, __zp($16) char radix)
utoa: {
    .label __4 = $d
    .label __10 = $e
    .label __11 = 4
    .label digit_value = 5
    .label buffer = 9
    .label digit = $b
    .label value = 2
    .label radix = $16
    .label started = $c
    .label max_digits = $13
    .label digit_values = 7
    // if(radix==DECIMAL)
    // [122] if(utoa::radix#0==DECIMAL) goto utoa::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #DECIMAL
    cmp.z radix
    beq __b2
    // utoa::@2
    // if(radix==HEXADECIMAL)
    // [123] if(utoa::radix#0==HEXADECIMAL) goto utoa::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #HEXADECIMAL
    cmp.z radix
    beq __b3
    // utoa::@3
    // if(radix==OCTAL)
    // [124] if(utoa::radix#0==OCTAL) goto utoa::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #OCTAL
    cmp.z radix
    beq __b4
    // utoa::@4
    // if(radix==BINARY)
    // [125] if(utoa::radix#0==BINARY) goto utoa::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #BINARY
    cmp.z radix
    beq __b5
    // utoa::@5
    // *buffer++ = 'e'
    // [126] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS) = 'e'pm -- _deref_pbuc1=vbuc2 
    // Unknown radix
    lda #'e'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    // *buffer++ = 'r'
    // [127] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1) = 'r'pm -- _deref_pbuc1=vbuc2 
    lda #'r'
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+1
    // [128] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2) = 'r'pm -- _deref_pbuc1=vbuc2 
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+2
    // *buffer = 0
    // [129] *((char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS+3
    // utoa::@return
    // }
    // [130] return 
    rts
    // [131] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
  __b2:
    // [131] phi utoa::digit_values#8 = RADIX_DECIMAL_VALUES [phi:utoa->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_DECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_DECIMAL_VALUES
    sta.z digit_values+1
    // [131] phi utoa::max_digits#7 = 5 [phi:utoa->utoa::@1#1] -- vbuz1=vbuc1 
    lda #5
    sta.z max_digits
    jmp __b1
    // [131] phi from utoa::@2 to utoa::@1 [phi:utoa::@2->utoa::@1]
  __b3:
    // [131] phi utoa::digit_values#8 = RADIX_HEXADECIMAL_VALUES [phi:utoa::@2->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_HEXADECIMAL_VALUES
    sta.z digit_values
    lda #>RADIX_HEXADECIMAL_VALUES
    sta.z digit_values+1
    // [131] phi utoa::max_digits#7 = 4 [phi:utoa::@2->utoa::@1#1] -- vbuz1=vbuc1 
    lda #4
    sta.z max_digits
    jmp __b1
    // [131] phi from utoa::@3 to utoa::@1 [phi:utoa::@3->utoa::@1]
  __b4:
    // [131] phi utoa::digit_values#8 = RADIX_OCTAL_VALUES [phi:utoa::@3->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_OCTAL_VALUES
    sta.z digit_values
    lda #>RADIX_OCTAL_VALUES
    sta.z digit_values+1
    // [131] phi utoa::max_digits#7 = 6 [phi:utoa::@3->utoa::@1#1] -- vbuz1=vbuc1 
    lda #6
    sta.z max_digits
    jmp __b1
    // [131] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
  __b5:
    // [131] phi utoa::digit_values#8 = RADIX_BINARY_VALUES [phi:utoa::@4->utoa::@1#0] -- pwuz1=pwuc1 
    lda #<RADIX_BINARY_VALUES
    sta.z digit_values
    lda #>RADIX_BINARY_VALUES
    sta.z digit_values+1
    // [131] phi utoa::max_digits#7 = $10 [phi:utoa::@4->utoa::@1#1] -- vbuz1=vbuc1 
    lda #$10
    sta.z max_digits
    // utoa::@1
  __b1:
    // [132] phi from utoa::@1 to utoa::@6 [phi:utoa::@1->utoa::@6]
    // [132] phi utoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa::@1->utoa::@6#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [132] phi utoa::started#2 = 0 [phi:utoa::@1->utoa::@6#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [132] phi utoa::value#2 = main::number [phi:utoa::@1->utoa::@6#2] -- vwuz1=vwuc1 
    lda #<main.number
    sta.z value
    lda #>main.number
    sta.z value+1
    // [132] phi utoa::digit#2 = 0 [phi:utoa::@1->utoa::@6#3] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // utoa::@6
  __b6:
    // max_digits-1
    // [133] utoa::$4 = utoa::max_digits#7 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z max_digits
    dex
    stx.z __4
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [134] if(utoa::digit#2<utoa::$4) goto utoa::@7 -- vbuz1_lt_vbuz2_then_la1 
    lda.z digit
    cmp.z __4
    bcc __b7
    // utoa::@8
    // *buffer++ = DIGITS[(char)value]
    // [135] utoa::$11 = (char)utoa::value#2 -- vbuz1=_byte_vwuz2 
    lda.z value
    sta.z __11
    // [136] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [137] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [138] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    rts
    // utoa::@7
  __b7:
    // unsigned int digit_value = digit_values[digit]
    // [139] utoa::$10 = utoa::digit#2 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z digit
    asl
    sta.z __10
    // [140] utoa::digit_value#0 = utoa::digit_values#8[utoa::$10] -- vwuz1=pwuz2_derefidx_vbuz3 
    tay
    lda (digit_values),y
    sta.z digit_value
    iny
    lda (digit_values),y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    // [141] if(0!=utoa::started#2) goto utoa::@10 -- 0_neq_vbuz1_then_la1 
    lda.z started
    bne __b10
    // utoa::@12
    // [142] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@10 -- vwuz1_ge_vwuz2_then_la1 
    lda.z digit_value+1
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b10
  !:
    bcc __b10
    // [143] phi from utoa::@12 to utoa::@9 [phi:utoa::@12->utoa::@9]
    // [143] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@12->utoa::@9#0] -- register_copy 
    // [143] phi utoa::started#4 = utoa::started#2 [phi:utoa::@12->utoa::@9#1] -- register_copy 
    // [143] phi utoa::value#6 = utoa::value#2 [phi:utoa::@12->utoa::@9#2] -- register_copy 
    // utoa::@9
  __b9:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [144] utoa::digit#1 = ++ utoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [132] phi from utoa::@9 to utoa::@6 [phi:utoa::@9->utoa::@6]
    // [132] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@9->utoa::@6#0] -- register_copy 
    // [132] phi utoa::started#2 = utoa::started#4 [phi:utoa::@9->utoa::@6#1] -- register_copy 
    // [132] phi utoa::value#2 = utoa::value#6 [phi:utoa::@9->utoa::@6#2] -- register_copy 
    // [132] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@9->utoa::@6#3] -- register_copy 
    jmp __b6
    // utoa::@10
  __b10:
    // utoa_append(buffer++, value, digit_value)
    // [145] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [146] utoa_append::value#0 = utoa::value#2
    // [147] utoa_append::sub#0 = utoa::digit_value#0
    // [148] call utoa_append
    // [195] phi from utoa::@10 to utoa_append [phi:utoa::@10->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [149] utoa_append::return#0 = utoa_append::value#2
    // utoa::@11
    // value = utoa_append(buffer++, value, digit_value)
    // [150] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [151] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [143] phi from utoa::@11 to utoa::@9 [phi:utoa::@11->utoa::@9]
    // [143] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@11->utoa::@9#0] -- register_copy 
    // [143] phi utoa::started#4 = 1 [phi:utoa::@11->utoa::@9#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [143] phi utoa::value#6 = utoa::value#0 [phi:utoa::@11->utoa::@9#2] -- register_copy 
    jmp __b9
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(__zp($11) void (*putc)(char), __zp($d) char buffer_sign, char *buffer_digits, __zp($1a) char format_min_length, char format_justify_left, char format_sign_always, __zp($19) char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label __19 = 9
    .label putc = $11
    .label buffer_sign = $d
    .label format_min_length = $1a
    .label format_zero_padding = $19
    .label len = $13
    .label padding = $13
    // if(format.min_length)
    // [152] if(0==printf_number_buffer::format_min_length#0) goto printf_number_buffer::@1 -- 0_eq_vbuz1_then_la1 
    lda.z format_min_length
    beq __b5
    // [153] phi from printf_number_buffer to printf_number_buffer::@5 [phi:printf_number_buffer->printf_number_buffer::@5]
    // printf_number_buffer::@5
    // strlen(buffer.digits)
    // [154] call strlen
    // [202] phi from printf_number_buffer::@5 to strlen [phi:printf_number_buffer::@5->strlen]
    jsr strlen
    // strlen(buffer.digits)
    // [155] strlen::return#2 = strlen::len#2
    // printf_number_buffer::@11
    // [156] printf_number_buffer::$19 = strlen::return#2
    // signed char len = (signed char)strlen(buffer.digits)
    // [157] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsz1=_sbyte_vwuz2 
    // There is a minimum length - work out the padding
    lda.z __19
    sta.z len
    // if(buffer.sign)
    // [158] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@10 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    beq __b10
    // printf_number_buffer::@6
    // len++;
    // [159] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsz1=_inc_vbsz1 
    inc.z len
    // [160] phi from printf_number_buffer::@11 printf_number_buffer::@6 to printf_number_buffer::@10 [phi:printf_number_buffer::@11/printf_number_buffer::@6->printf_number_buffer::@10]
    // [160] phi printf_number_buffer::len#2 = printf_number_buffer::len#0 [phi:printf_number_buffer::@11/printf_number_buffer::@6->printf_number_buffer::@10#0] -- register_copy 
    // printf_number_buffer::@10
  __b10:
    // padding = (signed char)format.min_length - len
    // [161] printf_number_buffer::padding#1 = (signed char)printf_number_buffer::format_min_length#0 - printf_number_buffer::len#2 -- vbsz1=vbsz2_minus_vbsz1 
    lda.z format_min_length
    sec
    sbc.z padding
    sta.z padding
    // if(padding<0)
    // [162] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@15 -- vbsz1_ge_0_then_la1 
    cmp #0
    bpl __b1
    // [164] phi from printf_number_buffer printf_number_buffer::@10 to printf_number_buffer::@1 [phi:printf_number_buffer/printf_number_buffer::@10->printf_number_buffer::@1]
  __b5:
    // [164] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer/printf_number_buffer::@10->printf_number_buffer::@1#0] -- vbsz1=vbsc1 
    lda #0
    sta.z padding
    // [163] phi from printf_number_buffer::@10 to printf_number_buffer::@15 [phi:printf_number_buffer::@10->printf_number_buffer::@15]
    // printf_number_buffer::@15
    // [164] phi from printf_number_buffer::@15 to printf_number_buffer::@1 [phi:printf_number_buffer::@15->printf_number_buffer::@1]
    // [164] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@15->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
  __b1:
    // printf_number_buffer::@13
    // if(!format.justify_left && !format.zero_padding && padding)
    // [165] if(0!=printf_number_buffer::format_zero_padding#0) goto printf_number_buffer::@2 -- 0_neq_vbuz1_then_la1 
    lda.z format_zero_padding
    bne __b2
    // printf_number_buffer::@12
    // [166] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@7 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b7
    jmp __b2
    // printf_number_buffer::@7
  __b7:
    // printf_padding(putc, ' ',(char)padding)
    // [167] printf_padding::putc#0 = printf_number_buffer::putc#0 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [168] printf_padding::length#0 = (char)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [169] call printf_padding
    // [208] phi from printf_number_buffer::@7 to printf_padding [phi:printf_number_buffer::@7->printf_padding]
    // [208] phi printf_padding::putc#7 = printf_padding::putc#0 [phi:printf_number_buffer::@7->printf_padding#0] -- register_copy 
    // [208] phi printf_padding::pad#7 = ' 'pm [phi:printf_number_buffer::@7->printf_padding#1] -- vbuz1=vbuc1 
    lda #' '
    sta.z printf_padding.pad
    // [208] phi printf_padding::length#6 = printf_padding::length#0 [phi:printf_number_buffer::@7->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [170] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@3 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    beq __b3
    // printf_number_buffer::@8
    // putc(buffer.sign)
    // [171] stackpush(char) = printf_number_buffer::buffer_sign#0 -- _stackpushbyte_=vbuz1 
    pha
    // [172] callexecute *printf_number_buffer::putc#0  -- call__deref_pprz1 
    jsr icall3
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@3
  __b3:
    // if(format.zero_padding && padding)
    // [174] if(0==printf_number_buffer::format_zero_padding#0) goto printf_number_buffer::@4 -- 0_eq_vbuz1_then_la1 
    lda.z format_zero_padding
    beq __b4
    // printf_number_buffer::@14
    // [175] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@9 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b9
    jmp __b4
    // printf_number_buffer::@9
  __b9:
    // printf_padding(putc, '0',(char)padding)
    // [176] printf_padding::putc#1 = printf_number_buffer::putc#0 -- pprz1=pprz2 
    lda.z putc
    sta.z printf_padding.putc
    lda.z putc+1
    sta.z printf_padding.putc+1
    // [177] printf_padding::length#1 = (char)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [178] call printf_padding
    // [208] phi from printf_number_buffer::@9 to printf_padding [phi:printf_number_buffer::@9->printf_padding]
    // [208] phi printf_padding::putc#7 = printf_padding::putc#1 [phi:printf_number_buffer::@9->printf_padding#0] -- register_copy 
    // [208] phi printf_padding::pad#7 = '0'pm [phi:printf_number_buffer::@9->printf_padding#1] -- vbuz1=vbuc1 
    lda #'0'
    sta.z printf_padding.pad
    // [208] phi printf_padding::length#6 = printf_padding::length#1 [phi:printf_number_buffer::@9->printf_padding#2] -- register_copy 
    jsr printf_padding
    // printf_number_buffer::@4
  __b4:
    // printf_str(putc, buffer.digits)
    // [179] printf_str::putc#0 = printf_number_buffer::putc#0
    // [180] call printf_str
    // [97] phi from printf_number_buffer::@4 to printf_str [phi:printf_number_buffer::@4->printf_str]
    // [97] phi printf_str::putc#8 = printf_str::putc#0 [phi:printf_number_buffer::@4->printf_str#0] -- register_copy 
    // [97] phi printf_str::s#8 = printf_number_buffer::buffer_digits#0 [phi:printf_number_buffer::@4->printf_str#1] -- pbuz1=pbuc1 
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
    // printf_number_buffer::@return
    // }
    // [181] return 
    rts
    // Outside Flow
  icall3:
    jmp (putc)
}
  // memcpy
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(void *destination, void *source, unsigned int num)
memcpy: {
    .const num = $19*$50-$50
    .label destination = DEFAULT_SCREEN
    .label source = DEFAULT_SCREEN+$50
    .label src_end = source+num
    .label dst = $17
    .label src = $14
    // [183] phi from memcpy to memcpy::@1 [phi:memcpy->memcpy::@1]
    // [183] phi memcpy::dst#2 = (char *)memcpy::destination#0 [phi:memcpy->memcpy::@1#0] -- pbuz1=pbuc1 
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    // [183] phi memcpy::src#2 = (char *)memcpy::source#0 [phi:memcpy->memcpy::@1#1] -- pbuz1=pbuc1 
    lda #<source
    sta.z src
    lda #>source
    sta.z src+1
    // memcpy::@1
  __b1:
    // while(src!=src_end)
    // [184] if(memcpy::src#2!=memcpy::src_end#0) goto memcpy::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z src+1
    cmp #>src_end
    bne __b2
    lda.z src
    cmp #<src_end
    bne __b2
    // memcpy::@return
    // }
    // [185] return 
    rts
    // memcpy::@2
  __b2:
    // *dst++ = *src++
    // [186] *memcpy::dst#2 = *memcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [187] memcpy::dst#1 = ++ memcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [188] memcpy::src#1 = ++ memcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [183] phi from memcpy::@2 to memcpy::@1 [phi:memcpy::@2->memcpy::@1]
    // [183] phi memcpy::dst#2 = memcpy::dst#1 [phi:memcpy::@2->memcpy::@1#0] -- register_copy 
    // [183] phi memcpy::src#2 = memcpy::src#1 [phi:memcpy::@2->memcpy::@1#1] -- register_copy 
    jmp __b1
}
  // memset
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $50
    .label str = DEFAULT_SCREEN+$19*$50-$50
    .label end = str+num
    .label dst = $14
    // [190] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [190] phi memset::dst#2 = (char *)memset::str#0 [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [191] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [192] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [193] *memset::dst#2 = memset::c#0 -- _deref_pbuz1=vbuc1 
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [194] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [190] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [190] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // utoa_append
// Used to convert a single digit of an unsigned number value to a string representation
// Counts a single digit up from '0' as long as the value is larger than sub.
// Each time the digit is increased sub is subtracted from value.
// - buffer : pointer to the char that receives the digit
// - value : The value where the digit will be derived from
// - sub : the value of a '1' in the digit. Subtracted continually while the digit is increased.
//        (For decimal the subs used are 10000, 1000, 100, 10, 1)
// returns : the value reduced by sub * digit so that it is less than sub.
// __zp(2) unsigned int utoa_append(__zp($f) char *buffer, __zp(2) unsigned int value, __zp(5) unsigned int sub)
utoa_append: {
    .label buffer = $f
    .label value = 2
    .label sub = 5
    .label return = 2
    .label digit = 4
    // [196] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [196] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // [196] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [197] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwuz1_ge_vwuz2_then_la1 
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    // utoa_append::@3
    // *buffer = DIGITS[digit]
    // [198] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [199] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [200] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // value -= sub
    // [201] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    // [196] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [196] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [196] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __zp(9) unsigned int strlen(__zp(2) char *str)
strlen: {
    .label len = 9
    .label str = 2
    .label return = 9
    // [203] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [203] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [203] phi strlen::str#3 = printf_number_buffer::buffer_digits#0 [phi:strlen->strlen::@1#1] -- pbuz1=pbuc1 
    lda #<printf_number_buffer.buffer_digits
    sta.z str
    lda #>printf_number_buffer.buffer_digits
    sta.z str+1
    // strlen::@1
  __b1:
    // while(*str)
    // [204] if(0!=*strlen::str#3) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [205] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [206] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [207] strlen::str#0 = ++ strlen::str#3 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [203] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [203] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [203] phi strlen::str#3 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
}
  // printf_padding
// Print a padding char a number of times
// void printf_padding(__zp(5) void (*putc)(char), __zp($c) char pad, __zp($b) char length)
printf_padding: {
    .label i = 4
    .label putc = 5
    .label length = $b
    .label pad = $c
    // [209] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [209] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [210] if(printf_padding::i#2<printf_padding::length#6) goto printf_padding::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z length
    bcc __b2
    // printf_padding::@return
    // }
    // [211] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [212] stackpush(char) = printf_padding::pad#7 -- _stackpushbyte_=vbuz1 
    lda.z pad
    pha
    // [213] callexecute *printf_padding::putc#7  -- call__deref_pprz1 
    jsr icall4
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [215] printf_padding::i#1 = ++ printf_padding::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [209] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [209] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
    // Outside Flow
  icall4:
    jmp (putc)
}
  // File Data
.segment Data
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of binary digits
  RADIX_BINARY_VALUES: .word $8000, $4000, $2000, $1000, $800, $400, $200, $100, $80, $40, $20, $10, 8, 4, 2
  // Values of octal digits
  RADIX_OCTAL_VALUES: .word $8000, $1000, $200, $40, 8
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  // Values of hexadecimal digits
  RADIX_HEXADECIMAL_VALUES: .word $1000, $100, $10
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0

  // File Comments
/// @file
/// Provides provide console input/output
///
/// Implements similar functions as conio.h from CC65 for compatibility
/// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
/// Currently CX16/C64/PLUS4/VIC20 platforms are supported
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16-mouse - coordinates.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  // Global Constants & labels
  .const WHITE = 1
  .const BLUE = 6
  .const VERA_INC_1 = $10
  .const VERA_ADDRSEL = 1
  .const VERA_LAYER_WIDTH_MASK = $30
  .const VERA_LAYER_HEIGHT_MASK = $c0
  ///< Load a logical file.
  .const CBM_PLOT = $fff0
  .const OFFSET_STRUCT_CX16_CONIO_WIDTH = 4
  .const OFFSET_STRUCT_CX16_CONIO_HEIGHT = 5
  // CX16 CBM Mouse Routines
  .const CX16_MOUSE_CONFIG = $ff68
  // ISR routine to scan the mouse state.
  .const CX16_MOUSE_GET = $ff6b
  .const OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS = 1
  .const OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET = 1
  .const OFFSET_STRUCT_CX16_CONIO_COLOR = $e
  .const OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT = 8
  .const OFFSET_STRUCT_CX16_CONIO_MAPWIDTH = 6
  .const OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK = 3
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR_X = $f
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR_Y = $10
  .const OFFSET_STRUCT_CX16_CONIO_LINE = $11
  .const OFFSET_STRUCT_CX16_CONIO_ROWSKIP = $b
  .const OFFSET_STRUCT_CX16_CONIO_ROWSHIFT = $a
  .const OFFSET_STRUCT_CX16_CONIO_SCROLL = $13
  .const OFFSET_STRUCT_CX16_CONIO_CURSOR = $d
  .const STACK_BASE = $103
  .const SIZEOF_STRUCT_CX16_CONIO = $15
  .const SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER = $c
  /// $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  /// $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  /// $9F22 VRAM Address (7:0)
  /// Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  ///                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  /// Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  /// Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  /// $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  /// $9F24	DATA1	VRAM Data port 1
  .label VERA_DATA1 = $9f24
  /// $9F25	CTRL Control
  /// Bit 7: Reset
  /// Bit 1: DCSEL
  /// Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  /// $9F2A	DC_HSCALE (DCSEL=0)	Active Display H-Scale
  .label VERA_DC_HSCALE = $9f2a
  /// $9F2B	DC_VSCALE (DCSEL=0)	Active Display V-Scale
  .label VERA_DC_VSCALE = $9f2b
  /// $9F34	L1_CONFIG   Layer 1 Configuration
  .label VERA_L1_CONFIG = $9f34
  /// $9F35	L1_MAPBASE	    Layer 1 Map Base Address (16:9)
  .label VERA_L1_MAPBASE = $9f35
  .label BRAM = 0
  // Get the mouse state;
  .label cx16_mousex = $67
  .label cx16_mousey = $65
.segment Code
  // __start
__start: {
    // __start::__init1
    // __address(0) char BRAM
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // volatile int cx16_mousex = 0
    // [2] cx16_mousex = 0 -- vwsz1=vwsc1 
    sta.z cx16_mousex
    sta.z cx16_mousex+1
    // volatile int cx16_mousey = 0
    // [3] cx16_mousey = 0 -- vwsz1=vwsc1 
    sta.z cx16_mousey
    sta.z cx16_mousey+1
    // #pragma constructor_for(conio_x16_init, cputc, clrscr, cscroll)
    // [4] call conio_x16_init
    jsr conio_x16_init
    // [5] phi from __start::__init1 to __start::@1 [phi:__start::__init1->__start::@1]
    // __start::@1
    // [6] call main
    // [65] phi from __start::@1 to main [phi:__start::@1->main]
    jsr main
    // __start::@return
    // [7] return 
    rts
}
  // conio_x16_init
// Set initial cursor position
conio_x16_init: {
    // // Position cursor at current line
    .label BASIC_CURSOR_LINE = $d6
    .label __8 = $50
    .label __9 = $60
    .label __10 = $50
    .label __11 = $61
    .label line = $69
    // char line = *BASIC_CURSOR_LINE
    // [8] conio_x16_init::line#0 = *conio_x16_init::BASIC_CURSOR_LINE -- vbuz1=_deref_pbuc1 
    lda.z BASIC_CURSOR_LINE
    sta.z line
    // screensize(&__conio.width, &__conio.height)
    // [9] call screensize
    // *VERA_L1_CONFIG &= ~VERA_LAYER_CONFIG_256C;
    // *VERA_L1_CONFIG |= VERA_LAYER_CONFIG_16C;
    jsr screensize
    // [10] phi from conio_x16_init to conio_x16_init::@3 [phi:conio_x16_init->conio_x16_init::@3]
    // conio_x16_init::@3
    // screenlayer1()
    // [11] call screenlayer1
    // TODO, this should become a ROM call for the CX16.
    jsr screenlayer1
    // [12] phi from conio_x16_init::@3 to conio_x16_init::@4 [phi:conio_x16_init::@3->conio_x16_init::@4]
    // conio_x16_init::@4
    // textcolor(WHITE)
    // [13] call textcolor
    jsr textcolor
    // [14] phi from conio_x16_init::@4 to conio_x16_init::@5 [phi:conio_x16_init::@4->conio_x16_init::@5]
    // conio_x16_init::@5
    // bgcolor(BLUE)
    // [15] call bgcolor
    jsr bgcolor
    // [16] phi from conio_x16_init::@5 to conio_x16_init::@6 [phi:conio_x16_init::@5->conio_x16_init::@6]
    // conio_x16_init::@6
    // cursor(0)
    // [17] call cursor
    jsr cursor
    // conio_x16_init::@7
    // if(line>=__conio.height)
    // [18] if(conio_x16_init::line#0<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto conio_x16_init::@1 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z line
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    // [19] phi from conio_x16_init::@7 to conio_x16_init::@2 [phi:conio_x16_init::@7->conio_x16_init::@2]
    // conio_x16_init::@2
    // [20] phi from conio_x16_init::@2 conio_x16_init::@7 to conio_x16_init::@1 [phi:conio_x16_init::@2/conio_x16_init::@7->conio_x16_init::@1]
    // conio_x16_init::@1
    // cbm_k_plot_get()
    // [21] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [22] cbm_k_plot_get::return#2 = cbm_k_plot_get::return#0
    // conio_x16_init::@8
    // [23] conio_x16_init::$8 = cbm_k_plot_get::return#2
    // BYTE1(cbm_k_plot_get())
    // [24] conio_x16_init::$9 = byte1  conio_x16_init::$8 -- vbuz1=_byte1_vwuz2 
    lda.z __8+1
    sta.z __9
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [25] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = conio_x16_init::$9 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // cbm_k_plot_get()
    // [26] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [27] cbm_k_plot_get::return#3 = cbm_k_plot_get::return#0
    // conio_x16_init::@9
    // [28] conio_x16_init::$10 = cbm_k_plot_get::return#3
    // BYTE0(cbm_k_plot_get())
    // [29] conio_x16_init::$11 = byte0  conio_x16_init::$10 -- vbuz1=_byte0_vwuz2 
    lda.z __10
    sta.z __11
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [30] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = conio_x16_init::$11 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // gotoxy(__conio.cursor_x, __conio.cursor_y)
    // [31] gotoxy::x#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    sta.z gotoxy.x
    // [32] gotoxy::y#1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    sta.z gotoxy.y
    // [33] call gotoxy
    // [146] phi from conio_x16_init::@9 to gotoxy [phi:conio_x16_init::@9->gotoxy]
    // [146] phi gotoxy::x#5 = gotoxy::x#1 [phi:conio_x16_init::@9->gotoxy#0] -- register_copy 
    // [146] phi gotoxy::y#5 = gotoxy::y#1 [phi:conio_x16_init::@9->gotoxy#1] -- register_copy 
    jsr gotoxy
    // conio_x16_init::@return
    // }
    // [34] return 
    rts
}
  // cputc
// Output one character at the current cursor position
// Moves the cursor forward. Scrolls the entire screen if needed
// void cputc(__zp($2e) char c)
cputc: {
    .const OFFSET_STACK_C = 0
    .label __1 = $3d
    .label __3 = $3e
    .label __4 = $3f
    .label __5 = $40
    .label __14 = $42
    .label c = $2e
    .label color = $49
    .label mapbase_offset = $22
    .label mapwidth = $4b
    .label conio_addr = $22
    .label scroll_enable = $41
    // [35] cputc::c#0 = stackidx(char,cputc::OFFSET_STACK_C) -- vbuz1=_stackidxbyte_vbuc1 
    tsx
    lda STACK_BASE+OFFSET_STACK_C,x
    sta.z c
    // char color = __conio.color
    // [36] cputc::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // unsigned int mapbase_offset = __conio.mapbase_offset
    // [37] cputc::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z mapbase_offset+1
    // unsigned int mapwidth = __conio.mapwidth
    // [38] cputc::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta.z mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta.z mapwidth+1
    // unsigned int conio_addr = mapbase_offset + __conio.line
    // [39] cputc::conio_addr#0 = cputc::mapbase_offset#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z conio_addr
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z conio_addr
    lda.z conio_addr+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z conio_addr+1
    // __conio.cursor_x << 1
    // [40] cputc::$1 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    asl
    sta.z __1
    // conio_addr += __conio.cursor_x << 1
    // [41] cputc::conio_addr#1 = cputc::conio_addr#0 + cputc::$1 -- vwuz1=vwuz1_plus_vbuz2 
    clc
    adc.z conio_addr
    sta.z conio_addr
    bcc !+
    inc.z conio_addr+1
  !:
    // if(c=='\n')
    // [42] if(cputc::c#0==' ') goto cputc::@1 -- vbuz1_eq_vbuc1_then_la1 
    lda #'\n'
    cmp.z c
    beq __b1
    // cputc::@2
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [43] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(conio_addr)
    // [44] cputc::$3 = byte0  cputc::conio_addr#1 -- vbuz1=_byte0_vwuz2 
    lda.z conio_addr
    sta.z __3
    // *VERA_ADDRX_L = BYTE0(conio_addr)
    // [45] *VERA_ADDRX_L = cputc::$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(conio_addr)
    // [46] cputc::$4 = byte1  cputc::conio_addr#1 -- vbuz1=_byte1_vwuz2 
    lda.z conio_addr+1
    sta.z __4
    // *VERA_ADDRX_M = BYTE1(conio_addr)
    // [47] *VERA_ADDRX_M = cputc::$4 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [48] cputc::$5 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta.z __5
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [49] *VERA_ADDRX_H = cputc::$5 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // *VERA_DATA0 = c
    // [50] *VERA_DATA0 = cputc::c#0 -- _deref_pbuc1=vbuz1 
    lda.z c
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [51] *VERA_DATA0 = cputc::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // __conio.cursor_x++;
    // [52] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // unsigned char scroll_enable = __conio.scroll[__conio.layer]
    // [53] cputc::scroll_enable#0 = ((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)] -- vbuz1=pbuc1_derefidx_(_deref_pbuc2) 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    sta.z scroll_enable
    // if(scroll_enable)
    // [54] if(0!=cputc::scroll_enable#0) goto cputc::@5 -- 0_neq_vbuz1_then_la1 
    bne __b5
    // cputc::@3
    // (unsigned int)__conio.cursor_x == mapwidth
    // [55] cputc::$14 = (unsigned int)*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) -- vwuz1=_word__deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    sta.z __14
    lda #0
    sta.z __14+1
    // if((unsigned int)__conio.cursor_x == mapwidth)
    // [56] if(cputc::$14!=cputc::mapwidth#0) goto cputc::@return -- vwuz1_neq_vwuz2_then_la1 
    cmp.z mapwidth+1
    bne __breturn
    lda.z __14
    cmp.z mapwidth
    bne __breturn
    // [57] phi from cputc::@3 to cputc::@4 [phi:cputc::@3->cputc::@4]
    // cputc::@4
    // cputln()
    // [58] call cputln
    jsr cputln
    // cputc::@return
  __breturn:
    // }
    // [59] return 
    rts
    // cputc::@5
  __b5:
    // if(__conio.cursor_x == __conio.width)
    // [60] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X)!=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto cputc::@return -- _deref_pbuc1_neq__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bne __breturn
    // [61] phi from cputc::@5 to cputc::@6 [phi:cputc::@5->cputc::@6]
    // cputc::@6
    // cputln()
    // [62] call cputln
    jsr cputln
    rts
    // [63] phi from cputc to cputc::@1 [phi:cputc->cputc::@1]
    // cputc::@1
  __b1:
    // cputln()
    // [64] call cputln
    jsr cputln
    rts
}
  // main
main: {
    .label __3 = $46
    // clrscr()
    // [66] call clrscr
    jsr clrscr
    // main::@3
    // cx16_mouse_config(0x01, 80, 60)
    // [67] cx16_mouse_config::visible = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z cx16_mouse_config.visible
    // [68] cx16_mouse_config::scalex = $50 -- vbuz1=vbuc1 
    lda #$50
    sta.z cx16_mouse_config.scalex
    // [69] cx16_mouse_config::scaley = $3c -- vbuz1=vbuc1 
    lda #$3c
    sta.z cx16_mouse_config.scaley
    // [70] call cx16_mouse_config
    jsr cx16_mouse_config
    // [71] phi from main::@3 to main::@4 [phi:main::@3->main::@4]
    // main::@4
    // printf("move the mouse, and check the registers updating correctly. press any key ...\n")
    // [72] call printf_str
    // [192] phi from main::@4 to printf_str [phi:main::@4->printf_str]
    // [192] phi printf_str::putc#6 = &cputc [phi:main::@4->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [192] phi printf_str::s#6 = main::s [phi:main::@4->printf_str#1] -- pbuz1=pbuc1 
    lda #<s
    sta.z printf_str.s
    lda #>s
    sta.z printf_str.s+1
    jsr printf_str
    // [73] phi from main::@10 main::@4 to main::@1 [phi:main::@10/main::@4->main::@1]
    // main::@1
  __b1:
    // getin()
    // [74] call getin
    jsr getin
    // [75] getin::return#2 = getin::return#1
    // main::@5
    // [76] main::$3 = getin::return#2
    // while(!getin())
    // [77] if(0==main::$3) goto main::@2 -- 0_eq_vbuz1_then_la1 
    lda.z __3
    beq __b2
    // main::@return
    // }
    // [78] return 
    rts
    // [79] phi from main::@5 to main::@2 [phi:main::@5->main::@2]
    // main::@2
  __b2:
    // char cx16_mouse_status = cx16_mouse_get()
    // [80] call cx16_mouse_get
    // loop until a key is pressed
    jsr cx16_mouse_get
    // [81] phi from main::@2 to main::@6 [phi:main::@2->main::@6]
    // main::@6
    // gotoxy(0,19)
    // [82] call gotoxy
  // get the mouse status, which puts the x and y coordinates in zero page $22
    // [146] phi from main::@6 to gotoxy [phi:main::@6->gotoxy]
    // [146] phi gotoxy::x#5 = 0 [phi:main::@6->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [146] phi gotoxy::y#5 = $13 [phi:main::@6->gotoxy#1] -- vbuz1=vbuc1 
    lda #$13
    sta.z gotoxy.y
    jsr gotoxy
    // [83] phi from main::@6 to main::@7 [phi:main::@6->main::@7]
    // main::@7
    // printf("coordinates : x=%03i, y=%03i", cx16_mousex, cx16_mousey)
    // [84] call printf_str
    // [192] phi from main::@7 to printf_str [phi:main::@7->printf_str]
    // [192] phi printf_str::putc#6 = &cputc [phi:main::@7->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [192] phi printf_str::s#6 = main::s1 [phi:main::@7->printf_str#1] -- pbuz1=pbuc1 
    lda #<s1
    sta.z printf_str.s
    lda #>s1
    sta.z printf_str.s+1
    jsr printf_str
    // main::@8
    // printf("coordinates : x=%03i, y=%03i", cx16_mousex, cx16_mousey)
    // [85] printf_sint::value#1 = cx16_mousex -- vwsz1=vwsz2 
    lda.z cx16_mousex
    sta.z printf_sint.value
    lda.z cx16_mousex+1
    sta.z printf_sint.value+1
    // [86] call printf_sint
    // [212] phi from main::@8 to printf_sint [phi:main::@8->printf_sint]
    // [212] phi printf_sint::value#3 = printf_sint::value#1 [phi:main::@8->printf_sint#0] -- register_copy 
    jsr printf_sint
    // [87] phi from main::@8 to main::@9 [phi:main::@8->main::@9]
    // main::@9
    // printf("coordinates : x=%03i, y=%03i", cx16_mousex, cx16_mousey)
    // [88] call printf_str
    // [192] phi from main::@9 to printf_str [phi:main::@9->printf_str]
    // [192] phi printf_str::putc#6 = &cputc [phi:main::@9->printf_str#0] -- pprz1=pprc1 
    lda #<cputc
    sta.z printf_str.putc
    lda #>cputc
    sta.z printf_str.putc+1
    // [192] phi printf_str::s#6 = main::s2 [phi:main::@9->printf_str#1] -- pbuz1=pbuc1 
    lda #<s2
    sta.z printf_str.s
    lda #>s2
    sta.z printf_str.s+1
    jsr printf_str
    // main::@10
    // printf("coordinates : x=%03i, y=%03i", cx16_mousex, cx16_mousey)
    // [89] printf_sint::value#2 = cx16_mousey -- vwsz1=vwsz2 
    lda.z cx16_mousey
    sta.z printf_sint.value
    lda.z cx16_mousey+1
    sta.z printf_sint.value+1
    // [90] call printf_sint
    // [212] phi from main::@10 to printf_sint [phi:main::@10->printf_sint]
    // [212] phi printf_sint::value#3 = printf_sint::value#2 [phi:main::@10->printf_sint#0] -- register_copy 
    jsr printf_sint
    jmp __b1
  .segment Data
    s: .text @"move the mouse, and check the registers updating correctly. press any key ...\n"
    .byte 0
    s1: .text "coordinates : x="
    .byte 0
    s2: .text ", y="
    .byte 0
}
.segment Code
  // screensize
// Return the current screen size.
// void screensize(char *x, char *y)
screensize: {
    .label x = __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    .label y = __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    .label __1 = $57
    .label __3 = $58
    .label hscale = $57
    .label vscale = $58
    // char hscale = (*VERA_DC_HSCALE) >> 7
    // [91] screensize::hscale#0 = *VERA_DC_HSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    // VERA returns in VERA_DC_HSCALE the value of 128 when 80 columns is used in text mode,
    // and the value of 64 when 40 columns is used in text mode.
    // Basically, 40 columns mode in the VERA is a double scan mode.
    // Same for the VERA_DC_VSCALE mode, but then the subdivision is 60 or 30 rows.
    // I still need to test the other modes, but this will suffice for now for the pure text modes.
    lda VERA_DC_HSCALE
    rol
    rol
    and #1
    sta.z hscale
    // 40 << hscale
    // [92] screensize::$1 = $28 << screensize::hscale#0 -- vbuz1=vbuc1_rol_vbuz1 
    lda #$28
    ldy.z __1
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z __1
    // *x = 40 << hscale
    // [93] *screensize::x#0 = screensize::$1 -- _deref_pbuc1=vbuz1 
    sta x
    // char vscale = (*VERA_DC_VSCALE) >> 7
    // [94] screensize::vscale#0 = *VERA_DC_VSCALE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_DC_VSCALE
    rol
    rol
    and #1
    sta.z vscale
    // 30 << vscale
    // [95] screensize::$3 = $1e << screensize::vscale#0 -- vbuz1=vbuc1_rol_vbuz1 
    lda #$1e
    ldy.z __3
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z __3
    // *y = 30 << vscale
    // [96] *screensize::y#0 = screensize::$3 -- _deref_pbuc1=vbuz1 
    sta y
    // screensize::@return
    // }
    // [97] return 
    rts
}
  // screenlayer1
// Set the layer with which the conio will interact.
// - layer: value of 0 or 1.
screenlayer1: {
    .label __0 = $57
    .label __1 = $58
    .label __2 = $5c
    .label __3 = $52
    .label __4 = $52
    .label __5 = $53
    .label __6 = $53
    .label __7 = $59
    .label __8 = $59
    .label __9 = $59
    .label __10 = $5a
    .label __11 = $5a
    .label __12 = $50
    .label __13 = $5e
    .label __14 = $50
    .label __15 = $5f
    .label __16 = $52
    .label __17 = $53
    .label __18 = $5a
    // __conio.layer = 1
    // [98] *((char *)&__conio) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta __conio
    // (*VERA_L1_MAPBASE)>>7
    // [99] screenlayer1::$0 = *VERA_L1_MAPBASE >> 7 -- vbuz1=_deref_pbuc1_ror_7 
    lda VERA_L1_MAPBASE
    rol
    rol
    and #1
    sta.z __0
    // __conio.mapbase_bank = (*VERA_L1_MAPBASE)>>7
    // [100] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) = screenlayer1::$0 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    // (*VERA_L1_MAPBASE)<<1
    // [101] screenlayer1::$1 = *VERA_L1_MAPBASE << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda VERA_L1_MAPBASE
    asl
    sta.z __1
    // MAKEWORD((*VERA_L1_MAPBASE)<<1,0)
    // [102] screenlayer1::$2 = screenlayer1::$1 w= 0 -- vwuz1=vbuz2_word_vbuc1 
    lda #0
    ldy.z __1
    sty.z __2+1
    sta.z __2
    // __conio.mapbase_offset = MAKEWORD((*VERA_L1_MAPBASE)<<1,0)
    // [103] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) = screenlayer1::$2 -- _deref_pwuc1=vwuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    tya
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    // *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK
    // [104] screenlayer1::$3 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __3
    // (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4
    // [105] screenlayer1::$4 = screenlayer1::$3 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __4
    lsr
    lsr
    lsr
    lsr
    sta.z __4
    // __conio.mapwidth = VERA_LAYER_WIDTH[ (*VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK) >> 4]
    // [106] screenlayer1::$16 = screenlayer1::$4 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __16
    // [107] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) = VERA_LAYER_WIDTH[screenlayer1::$16] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __16
    lda VERA_LAYER_WIDTH,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    lda VERA_LAYER_WIDTH+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    // *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK
    // [108] screenlayer1::$5 = *VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_HEIGHT_MASK
    and VERA_L1_CONFIG
    sta.z __5
    // (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6
    // [109] screenlayer1::$6 = screenlayer1::$5 >> 6 -- vbuz1=vbuz1_ror_6 
    lda.z __6
    rol
    rol
    rol
    and #3
    sta.z __6
    // __conio.mapheight = VERA_LAYER_HEIGHT[ (*VERA_L1_CONFIG & VERA_LAYER_HEIGHT_MASK) >> 6]
    // [110] screenlayer1::$17 = screenlayer1::$6 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __17
    // [111] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) = VERA_LAYER_HEIGHT[screenlayer1::$17] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __17
    lda VERA_LAYER_HEIGHT,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    lda VERA_LAYER_HEIGHT+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    // (*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [112] screenlayer1::$7 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __7
    // ((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [113] screenlayer1::$8 = screenlayer1::$7 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __8
    lsr
    lsr
    lsr
    lsr
    sta.z __8
    // (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [114] screenlayer1::$9 = screenlayer1::$8 + 6 -- vbuz1=vbuz1_plus_vbuc1 
    lda #6
    clc
    adc.z __9
    sta.z __9
    // __conio.rowshift = (((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4)+6
    // [115] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) = screenlayer1::$9 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    // (*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK
    // [116] screenlayer1::$10 = *VERA_L1_CONFIG & VERA_LAYER_WIDTH_MASK -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER_WIDTH_MASK
    and VERA_L1_CONFIG
    sta.z __10
    // ((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4
    // [117] screenlayer1::$11 = screenlayer1::$10 >> 4 -- vbuz1=vbuz1_ror_4 
    lda.z __11
    lsr
    lsr
    lsr
    lsr
    sta.z __11
    // __conio.rowskip = VERA_LAYER_SKIP[((*VERA_L1_CONFIG)&VERA_LAYER_WIDTH_MASK)>>4]
    // [118] screenlayer1::$18 = screenlayer1::$11 << 1 -- vbuz1=vbuz1_rol_1 
    asl.z __18
    // [119] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) = VERA_LAYER_SKIP[screenlayer1::$18] -- _deref_pwuc1=pwuc2_derefidx_vbuz1 
    ldy.z __18
    lda VERA_LAYER_SKIP,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    lda VERA_LAYER_SKIP+1,y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    // cbm_k_plot_get()
    // [120] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [121] cbm_k_plot_get::return#4 = cbm_k_plot_get::return#0
    // screenlayer1::@1
    // [122] screenlayer1::$12 = cbm_k_plot_get::return#4
    // BYTE1(cbm_k_plot_get())
    // [123] screenlayer1::$13 = byte1  screenlayer1::$12 -- vbuz1=_byte1_vwuz2 
    lda.z __12+1
    sta.z __13
    // __conio.cursor_x = BYTE1(cbm_k_plot_get())
    // [124] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = screenlayer1::$13 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // cbm_k_plot_get()
    // [125] call cbm_k_plot_get
    jsr cbm_k_plot_get
    // [126] cbm_k_plot_get::return#10 = cbm_k_plot_get::return#0
    // screenlayer1::@2
    // [127] screenlayer1::$14 = cbm_k_plot_get::return#10
    // BYTE0(cbm_k_plot_get())
    // [128] screenlayer1::$15 = byte0  screenlayer1::$14 -- vbuz1=_byte0_vwuz2 
    lda.z __14
    sta.z __15
    // __conio.cursor_y = BYTE0(cbm_k_plot_get())
    // [129] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = screenlayer1::$15 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // screenlayer1::@return
    // }
    // [130] return 
    rts
}
  // textcolor
// Set the front color for text output. The old front text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char textcolor(char color)
textcolor: {
    .label __0 = $52
    .label __1 = $52
    // __conio.color & 0xF0
    // [131] textcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f0 -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$f0
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z __0
    // __conio.color & 0xF0 | color
    // [132] textcolor::$1 = textcolor::$0 | WHITE -- vbuz1=vbuz1_bor_vbuc1 
    lda #WHITE
    ora.z __1
    sta.z __1
    // __conio.color = __conio.color & 0xF0 | color
    // [133] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = textcolor::$1 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // textcolor::@return
    // }
    // [134] return 
    rts
}
  // bgcolor
// Set the back color for text output. The old back text color setting is returned.
// - color: a 4 bit value ( decimal between 0 and 15).
//   This will only work when the VERA is in 16 color mode!
//   Note that on the VERA, the transparent color has value 0.
// char bgcolor(char color)
bgcolor: {
    .label __0 = $53
    .label __2 = $53
    // __conio.color & 0x0F
    // [135] bgcolor::$0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) & $f -- vbuz1=_deref_pbuc1_band_vbuc2 
    lda #$f
    and __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z __0
    // __conio.color & 0x0F | color << 4
    // [136] bgcolor::$2 = bgcolor::$0 | BLUE<<4 -- vbuz1=vbuz1_bor_vbuc1 
    lda #BLUE<<4
    ora.z __2
    sta.z __2
    // __conio.color = __conio.color & 0x0F | color << 4
    // [137] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) = bgcolor::$2 -- _deref_pbuc1=vbuz1 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    // bgcolor::@return
    // }
    // [138] return 
    rts
}
  // cursor
// If onoff is 1, a cursor is displayed when waiting for keyboard input.
// If onoff is 0, the cursor is hidden when waiting for keyboard input.
// The function returns the old cursor setting.
// char cursor(char onoff)
cursor: {
    .const onoff = 0
    // __conio.cursor = onoff
    // [139] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR) = cursor::onoff#0 -- _deref_pbuc1=vbuc2 
    lda #onoff
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR
    // cursor::@return
    // }
    // [140] return 
    rts
}
  // cbm_k_plot_get
/**
 * @brief Get current x and y cursor position.
 * @return An unsigned int where the hi byte is the x coordinate and the low byte is the y coordinate of the screen position.
 */
cbm_k_plot_get: {
    .label x = $56
    .label y = $54
    .label return = $50
    // unsigned char x
    // [141] cbm_k_plot_get::x = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // unsigned char y
    // [142] cbm_k_plot_get::y = 0 -- vbuz1=vbuc1 
    sta.z y
    // kickasm
    // kickasm( uses cbm_k_plot_get::x uses cbm_k_plot_get::y uses CBM_PLOT) {{ sec         jsr CBM_PLOT         stx y         sty x      }}
    sec
        jsr CBM_PLOT
        stx y
        sty x
    
    // MAKEWORD(x,y)
    // [144] cbm_k_plot_get::return#0 = cbm_k_plot_get::x w= cbm_k_plot_get::y -- vwuz1=vbuz2_word_vbuz3 
    lda.z x
    sta.z return+1
    lda.z y
    sta.z return
    // cbm_k_plot_get::@return
    // }
    // [145] return 
    rts
}
  // gotoxy
// Set the cursor to the specified position
// void gotoxy(__zp($34) char x, __zp($35) char y)
gotoxy: {
    .label __5 = $32
    .label line_offset = $32
    .label x = $34
    .label y = $35
    // if(y>__conio.height)
    // [147] if(gotoxy::y#5<=*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto gotoxy::@3 -- vbuz1_le__deref_pbuc1_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    cmp.z y
    bcs __b1
    // [149] phi from gotoxy to gotoxy::@1 [phi:gotoxy->gotoxy::@1]
    // [149] phi gotoxy::y#6 = 0 [phi:gotoxy->gotoxy::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z y
    // [148] phi from gotoxy to gotoxy::@3 [phi:gotoxy->gotoxy::@3]
    // gotoxy::@3
    // [149] phi from gotoxy::@3 to gotoxy::@1 [phi:gotoxy::@3->gotoxy::@1]
    // [149] phi gotoxy::y#6 = gotoxy::y#5 [phi:gotoxy::@3->gotoxy::@1#0] -- register_copy 
    // gotoxy::@1
  __b1:
    // if(x>=__conio.width)
    // [150] if(gotoxy::x#5<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto gotoxy::@4 -- vbuz1_lt__deref_pbuc1_then_la1 
    lda.z x
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
    // [152] phi from gotoxy::@1 to gotoxy::@2 [phi:gotoxy::@1->gotoxy::@2]
    // [152] phi gotoxy::x#6 = 0 [phi:gotoxy::@1->gotoxy::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z x
    // [151] phi from gotoxy::@1 to gotoxy::@4 [phi:gotoxy::@1->gotoxy::@4]
    // gotoxy::@4
    // [152] phi from gotoxy::@4 to gotoxy::@2 [phi:gotoxy::@4->gotoxy::@2]
    // [152] phi gotoxy::x#6 = gotoxy::x#5 [phi:gotoxy::@4->gotoxy::@2#0] -- register_copy 
    // gotoxy::@2
  __b2:
    // __conio.cursor_x = x
    // [153] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = gotoxy::x#6 -- _deref_pbuc1=vbuz1 
    lda.z x
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y = y
    // [154] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = gotoxy::y#6 -- _deref_pbuc1=vbuz1 
    lda.z y
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // unsigned int line_offset = (unsigned int)y << __conio.rowshift
    // [155] gotoxy::$5 = (unsigned int)gotoxy::y#6 -- vwuz1=_word_vbuz2 
    lda.z y
    sta.z __5
    lda #0
    sta.z __5+1
    // [156] gotoxy::line_offset#0 = gotoxy::$5 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwuz1=vwuz1_rol__deref_pbuc1 
    ldy __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    beq !e+
  !:
    asl.z line_offset
    rol.z line_offset+1
    dey
    bne !-
  !e:
    // __conio.line = line_offset
    // [157] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = gotoxy::line_offset#0 -- _deref_pwuc1=vwuz1 
    lda.z line_offset
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    lda.z line_offset+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // gotoxy::@return
    // }
    // [158] return 
    rts
}
  // cputln
// Print a newline
cputln: {
    .label temp = $39
    // unsigned int temp = __conio.line
    // [159] cputln::temp#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=_deref_pwuc1 
    // TODO: This needs to be optimized! other variations don't compile because of sections not available!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z temp
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z temp+1
    // temp += __conio.rowskip
    // [160] cputln::temp#1 = cputln::temp#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z temp
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z temp
    lda.z temp+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z temp+1
    // __conio.line = temp
    // [161] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = cputln::temp#1 -- _deref_pwuc1=vwuz1 
    lda.z temp
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    lda.z temp+1
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // __conio.cursor_x = 0
    // [162] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y++;
    // [163] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = ++ *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // cscroll()
    // [164] call cscroll
    jsr cscroll
    // cputln::@return
    // }
    // [165] return 
    rts
}
  // clrscr
// clears the screen and moves the cursor to the upper left-hand corner of the screen.
clrscr: {
    .label __1 = $38
    .label __2 = $4f
    .label __3 = $4e
    .label line_text = $44
    .label color = $4a
    .label mapheight = $47
    .label mapwidth = $3b
    .label c = $4d
    .label l = $46
    // unsigned int line_text = __conio.mapbase_offset
    // [166] clrscr::line_text#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z line_text
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z line_text+1
    // char color = __conio.color
    // [167] clrscr::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // unsigned int mapheight = __conio.mapheight
    // [168] clrscr::mapheight#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT
    sta.z mapheight
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPHEIGHT+1
    sta.z mapheight+1
    // unsigned int mapwidth = __conio.mapwidth
    // [169] clrscr::mapwidth#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH
    sta.z mapwidth
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPWIDTH+1
    sta.z mapwidth+1
    // [170] phi from clrscr to clrscr::@1 [phi:clrscr->clrscr::@1]
    // [170] phi clrscr::line_text#2 = clrscr::line_text#0 [phi:clrscr->clrscr::@1#0] -- register_copy 
    // [170] phi clrscr::l#2 = 0 [phi:clrscr->clrscr::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z l
    // clrscr::@1
  __b1:
    // for( char l=0;l<mapheight; l++ )
    // [171] if(clrscr::l#2<clrscr::mapheight#0) goto clrscr::@2 -- vbuz1_lt_vwuz2_then_la1 
    lda.z mapheight+1
    bne __b2
    lda.z l
    cmp.z mapheight
    bcc __b2
    // clrscr::@3
    // __conio.cursor_x = 0
    // [172] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // __conio.cursor_y = 0
    // [173] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) = 0 -- _deref_pbuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    // __conio.line = 0
    // [174] *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) = 0 -- _deref_pwuc1=vbuc2 
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    // clrscr::@return
    // }
    // [175] return 
    rts
    // clrscr::@2
  __b2:
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [176] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(ch)
    // [177] clrscr::$1 = byte0  clrscr::line_text#2 -- vbuz1=_byte0_vwuz2 
    lda.z line_text
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(ch)
    // [178] *VERA_ADDRX_L = clrscr::$1 -- _deref_pbuc1=vbuz1 
    // Set address
    sta VERA_ADDRX_L
    // BYTE1(ch)
    // [179] clrscr::$2 = byte1  clrscr::line_text#2 -- vbuz1=_byte1_vwuz2 
    lda.z line_text+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(ch)
    // [180] *VERA_ADDRX_M = clrscr::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // __conio.mapbase_bank | VERA_INC_1
    // [181] clrscr::$3 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK) | VERA_INC_1 -- vbuz1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_INC_1
    ora __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_BANK
    sta.z __3
    // *VERA_ADDRX_H = __conio.mapbase_bank | VERA_INC_1
    // [182] *VERA_ADDRX_H = clrscr::$3 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_H
    // [183] phi from clrscr::@2 to clrscr::@4 [phi:clrscr::@2->clrscr::@4]
    // [183] phi clrscr::c#2 = 0 [phi:clrscr::@2->clrscr::@4#0] -- vbuz1=vbuc1 
    lda #0
    sta.z c
    // clrscr::@4
  __b4:
    // for( char c=0;c<mapwidth; c++ )
    // [184] if(clrscr::c#2<clrscr::mapwidth#0) goto clrscr::@5 -- vbuz1_lt_vwuz2_then_la1 
    lda.z mapwidth+1
    bne __b5
    lda.z c
    cmp.z mapwidth
    bcc __b5
    // clrscr::@6
    // line_text += __conio.rowskip
    // [185] clrscr::line_text#1 = clrscr::line_text#2 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz1_plus__deref_pwuc1 
    clc
    lda.z line_text
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z line_text
    lda.z line_text+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z line_text+1
    // for( char l=0;l<mapheight; l++ )
    // [186] clrscr::l#1 = ++ clrscr::l#2 -- vbuz1=_inc_vbuz1 
    inc.z l
    // [170] phi from clrscr::@6 to clrscr::@1 [phi:clrscr::@6->clrscr::@1]
    // [170] phi clrscr::line_text#2 = clrscr::line_text#1 [phi:clrscr::@6->clrscr::@1#0] -- register_copy 
    // [170] phi clrscr::l#2 = clrscr::l#1 [phi:clrscr::@6->clrscr::@1#1] -- register_copy 
    jmp __b1
    // clrscr::@5
  __b5:
    // *VERA_DATA0 = ' '
    // [187] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [188] *VERA_DATA0 = clrscr::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( char c=0;c<mapwidth; c++ )
    // [189] clrscr::c#1 = ++ clrscr::c#2 -- vbuz1=_inc_vbuz1 
    inc.z c
    // [183] phi from clrscr::@5 to clrscr::@4 [phi:clrscr::@5->clrscr::@4]
    // [183] phi clrscr::c#2 = clrscr::c#1 [phi:clrscr::@5->clrscr::@4#0] -- register_copy 
    jmp __b4
}
  // cx16_mouse_config
/**
 * @brief Configures the mouse pointer.
 * 
 * 
 * @param visible Turn the mouse pointer on or off. Provide a value of 0xFF to set your own mouse pointer graphic (sprite 0).
 * @param scalex Specify x axis screen resolution in 8 pixel increments.
 * @param scaley Specify y axis screen resolution in 8 pixel increments.
 * 
 */
// void cx16_mouse_config(__zp($64) volatile char visible, __zp($63) volatile char scalex, __zp($62) volatile char scaley)
cx16_mouse_config: {
    .label visible = $64
    .label scalex = $63
    .label scaley = $62
    // asm
    // asm { ldavisible ldxscalex ldyscaley jsrCX16_MOUSE_CONFIG  }
    lda visible
    ldx scalex
    ldy scaley
    jsr CX16_MOUSE_CONFIG
    // cx16_mouse_config::@return
    // }
    // [191] return 
    rts
}
  // printf_str
/// Print a NUL-terminated string
// void printf_str(__zp($44) void (*putc)(char), __zp($36) const char *s)
printf_str: {
    .label c = $4a
    .label s = $36
    .label putc = $44
    // [193] phi from printf_str printf_str::@2 to printf_str::@1 [phi:printf_str/printf_str::@2->printf_str::@1]
    // [193] phi printf_str::s#5 = printf_str::s#6 [phi:printf_str/printf_str::@2->printf_str::@1#0] -- register_copy 
    // printf_str::@1
  __b1:
    // while(c=*s++)
    // [194] printf_str::c#1 = *printf_str::s#5 -- vbuz1=_deref_pbuz2 
    ldy #0
    lda (s),y
    sta.z c
    // [195] printf_str::s#0 = ++ printf_str::s#5 -- pbuz1=_inc_pbuz1 
    inc.z s
    bne !+
    inc.z s+1
  !:
    // [196] if(0!=printf_str::c#1) goto printf_str::@2 -- 0_neq_vbuz1_then_la1 
    lda.z c
    bne __b2
    // printf_str::@return
    // }
    // [197] return 
    rts
    // printf_str::@2
  __b2:
    // putc(c)
    // [198] stackpush(char) = printf_str::c#1 -- _stackpushbyte_=vbuz1 
    lda.z c
    pha
    // [199] callexecute *printf_str::putc#6  -- call__deref_pprz1 
    jsr icall1
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    jmp __b1
    // Outside Flow
  icall1:
    jmp (putc)
}
  // getin
/**
 * @brief Get a character from keyboard.
 * 
 * @return char The character read.
 */
getin: {
    .const bank_set_bram1_bank = 0
    .label ch = $5b
    .label bank_get_bram1_return = $38
    .label return = $46
    // char ch
    // [201] getin::ch = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z ch
    // getin::bank_get_bram1
    // return BRAM;
    // [202] getin::bank_get_bram1_return#0 = BRAM -- vbuz1=vbuz2 
    lda.z BRAM
    sta.z bank_get_bram1_return
    // getin::bank_set_bram1
    // BRAM = bank
    // [203] BRAM = getin::bank_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_bram1_bank
    sta.z BRAM
    // getin::@1
    // asm
    // asm { jsr$ffe4 stach  }
    jsr $ffe4
    sta ch
    // getin::bank_set_bram2
    // BRAM = bank
    // [205] BRAM = getin::bank_get_bram1_return#0 -- vbuz1=vbuz2 
    lda.z bank_get_bram1_return
    sta.z BRAM
    // getin::@2
    // return ch;
    // [206] getin::return#0 = getin::ch -- vbuz1=vbuz2 
    lda.z ch
    sta.z return
    // getin::@return
    // }
    // [207] getin::return#1 = getin::return#0
    // [208] return 
    rts
}
  // cx16_mouse_get
/**
 * @brief Retrieves the status of the mouse pointer and will fill the mouse position in the defined mouse registers.
 * 
 * @return char Current mouse status.
 * 
 * The pre-defined variables cx16_mousex and cx16_mousey contain the position of the mouse pointer.
 * 
 *     volatile int cx16_mousex = 0;
 *     volatile int cx16_mousey = 0;
 * 
 * The state of the mouse buttons is returned:
 * 
 *   |Bit|Description|
 *   |---|-----------|
 *   |0|Left Button|
 *   |1|Right Button|
 *   |2|Middle Button|
 * 
 *   If a button is pressed, the corresponding bit is set.
 */
cx16_mouse_get: {
    .label status = $55
    // char status
    // [209] cx16_mouse_get::status = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z status
    // asm
    // asm { ldx#$fc jsrCX16_MOUSE_GET stastatus lda$fc stacx16_mousex lda$fd stacx16_mousex+1 lda$fe stacx16_mousey lda$ff stacx16_mousey+1  }
    ldx #$fc
    jsr CX16_MOUSE_GET
    sta status
    lda.z $fc
    sta cx16_mousex
    lda.z $fd
    sta cx16_mousex+1
    lda.z $fe
    sta cx16_mousey
    lda.z $ff
    sta cx16_mousey+1
    // cx16_mouse_get::@return
    // }
    // [211] return 
    rts
}
  // printf_sint
// Print a signed integer using a specific format
// void printf_sint(void (*putc)(char), __zp($36) int value, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_sint: {
    .label value = $36
    // printf_buffer.sign = 0
    // [213] *((char *)&printf_buffer) = 0 -- _deref_pbuc1=vbuc2 
    // Handle any sign
    lda #0
    sta printf_buffer
    // if(value<0)
    // [214] if(printf_sint::value#3<0) goto printf_sint::@1 -- vwsz1_lt_0_then_la1 
    lda.z value+1
    bmi __b1
    // [217] phi from printf_sint printf_sint::@1 to printf_sint::@2 [phi:printf_sint/printf_sint::@1->printf_sint::@2]
    // [217] phi printf_sint::value#5 = printf_sint::value#3 [phi:printf_sint/printf_sint::@1->printf_sint::@2#0] -- register_copy 
    jmp __b2
    // printf_sint::@1
  __b1:
    // value = -value
    // [215] printf_sint::value#0 = - printf_sint::value#3 -- vwsz1=_neg_vwsz1 
    lda #0
    sec
    sbc.z value
    sta.z value
    lda #0
    sbc.z value+1
    sta.z value+1
    // printf_buffer.sign = '-'
    // [216] *((char *)&printf_buffer) = '-' -- _deref_pbuc1=vbuc2 
    lda #'-'
    sta printf_buffer
    // printf_sint::@2
  __b2:
    // utoa(uvalue, printf_buffer.digits, format.radix)
    // [218] utoa::value#1 = (unsigned int)printf_sint::value#5
    // [219] call utoa
    // [235] phi from printf_sint::@2 to utoa [phi:printf_sint::@2->utoa]
    jsr utoa
    // printf_sint::@3
    // printf_number_buffer(putc, printf_buffer, format)
    // [220] printf_number_buffer::buffer_sign#0 = *((char *)&printf_buffer) -- vbuz1=_deref_pbuc1 
    lda printf_buffer
    sta.z printf_number_buffer.buffer_sign
    // [221] call printf_number_buffer
  // Print using format
    // [256] phi from printf_sint::@3 to printf_number_buffer [phi:printf_sint::@3->printf_number_buffer]
    jsr printf_number_buffer
    // printf_sint::@return
    // }
    // [222] return 
    rts
}
  // cscroll
// Scroll the entire screen if the cursor is beyond the last line
cscroll: {
    // if(__conio.cursor_y>=__conio.height)
    // [223] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __breturn
    // cscroll::@1
    // if(__conio.scroll[__conio.layer])
    // [224] if(0!=((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_SCROLL)[*((char *)&__conio)]) goto cscroll::@4 -- 0_neq_pbuc1_derefidx_(_deref_pbuc2)_then_la1 
    ldy __conio
    lda __conio+OFFSET_STRUCT_CX16_CONIO_SCROLL,y
    cmp #0
    bne __b4
    // cscroll::@2
    // if(__conio.cursor_y>=__conio.height)
    // [225] if(*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y)<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT)) goto cscroll::@return -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    bcc __breturn
    // [226] phi from cscroll::@2 to cscroll::@3 [phi:cscroll::@2->cscroll::@3]
    // cscroll::@3
    // gotoxy(0,0)
    // [227] call gotoxy
    // [146] phi from cscroll::@3 to gotoxy [phi:cscroll::@3->gotoxy]
    // [146] phi gotoxy::x#5 = 0 [phi:cscroll::@3->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [146] phi gotoxy::y#5 = 0 [phi:cscroll::@3->gotoxy#1] -- vbuz1=vbuc1 
    sta.z gotoxy.y
    jsr gotoxy
    // cscroll::@return
  __breturn:
    // }
    // [228] return 
    rts
    // [229] phi from cscroll::@1 to cscroll::@4 [phi:cscroll::@1->cscroll::@4]
    // cscroll::@4
  __b4:
    // insertup()
    // [230] call insertup
    jsr insertup
    // cscroll::@5
    // gotoxy( 0, __conio.height-1)
    // [231] gotoxy::y#2 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT) - 1 -- vbuz1=_deref_pbuc1_minus_1 
    ldx __conio+OFFSET_STRUCT_CX16_CONIO_HEIGHT
    dex
    stx.z gotoxy.y
    // [232] call gotoxy
    // [146] phi from cscroll::@5 to gotoxy [phi:cscroll::@5->gotoxy]
    // [146] phi gotoxy::x#5 = 0 [phi:cscroll::@5->gotoxy#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gotoxy.x
    // [146] phi gotoxy::y#5 = gotoxy::y#2 [phi:cscroll::@5->gotoxy#1] -- register_copy 
    jsr gotoxy
    // [233] phi from cscroll::@5 to cscroll::@6 [phi:cscroll::@5->cscroll::@6]
    // cscroll::@6
    // clearline()
    // [234] call clearline
    jsr clearline
    rts
}
  // utoa
// Converts unsigned number value to a string representing it in RADIX format.
// If the leading digits are zero they are not included in the string.
// - value : The number to be converted to RADIX
// - buffer : receives the string representing the number and zero-termination.
// - radix : The radix to convert the number to (from the enum RADIX)
// void utoa(__zp($36) unsigned int value, __zp($44) char *buffer, char radix)
utoa: {
    .label __10 = $4a
    .label __11 = $4e
    .label digit_value = $3b
    .label buffer = $44
    .label digit = $46
    .label value = $36
    .label started = $4d
    // [236] phi from utoa to utoa::@1 [phi:utoa->utoa::@1]
    // [236] phi utoa::buffer#11 = (char *)&printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS [phi:utoa->utoa::@1#0] -- pbuz1=pbuc1 
    lda #<printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer
    lda #>printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    sta.z buffer+1
    // [236] phi utoa::started#2 = 0 [phi:utoa->utoa::@1#1] -- vbuz1=vbuc1 
    lda #0
    sta.z started
    // [236] phi utoa::value#2 = utoa::value#1 [phi:utoa->utoa::@1#2] -- register_copy 
    // [236] phi utoa::digit#2 = 0 [phi:utoa->utoa::@1#3] -- vbuz1=vbuc1 
    sta.z digit
    // utoa::@1
  __b1:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [237] if(utoa::digit#2<5-1) goto utoa::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z digit
    cmp #5-1
    bcc __b2
    // utoa::@3
    // *buffer++ = DIGITS[(char)value]
    // [238] utoa::$11 = (char)utoa::value#2 -- vbuz1=_byte_vwuz2 
    lda.z value
    sta.z __11
    // [239] *utoa::buffer#11 = DIGITS[utoa::$11] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    tay
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // *buffer++ = DIGITS[(char)value];
    // [240] utoa::buffer#3 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // *buffer = 0
    // [241] *utoa::buffer#3 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (buffer),y
    // utoa::@return
    // }
    // [242] return 
    rts
    // utoa::@2
  __b2:
    // unsigned int digit_value = digit_values[digit]
    // [243] utoa::$10 = utoa::digit#2 << 1 -- vbuz1=vbuz2_rol_1 
    lda.z digit
    asl
    sta.z __10
    // [244] utoa::digit_value#0 = RADIX_DECIMAL_VALUES[utoa::$10] -- vwuz1=pwuc1_derefidx_vbuz2 
    tay
    lda RADIX_DECIMAL_VALUES,y
    sta.z digit_value
    lda RADIX_DECIMAL_VALUES+1,y
    sta.z digit_value+1
    // if (started || value >= digit_value)
    // [245] if(0!=utoa::started#2) goto utoa::@5 -- 0_neq_vbuz1_then_la1 
    lda.z started
    bne __b5
    // utoa::@7
    // [246] if(utoa::value#2>=utoa::digit_value#0) goto utoa::@5 -- vwuz1_ge_vwuz2_then_la1 
    lda.z digit_value+1
    cmp.z value+1
    bne !+
    lda.z digit_value
    cmp.z value
    beq __b5
  !:
    bcc __b5
    // [247] phi from utoa::@7 to utoa::@4 [phi:utoa::@7->utoa::@4]
    // [247] phi utoa::buffer#14 = utoa::buffer#11 [phi:utoa::@7->utoa::@4#0] -- register_copy 
    // [247] phi utoa::started#4 = utoa::started#2 [phi:utoa::@7->utoa::@4#1] -- register_copy 
    // [247] phi utoa::value#6 = utoa::value#2 [phi:utoa::@7->utoa::@4#2] -- register_copy 
    // utoa::@4
  __b4:
    // for( char digit=0; digit<max_digits-1; digit++ )
    // [248] utoa::digit#1 = ++ utoa::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // [236] phi from utoa::@4 to utoa::@1 [phi:utoa::@4->utoa::@1]
    // [236] phi utoa::buffer#11 = utoa::buffer#14 [phi:utoa::@4->utoa::@1#0] -- register_copy 
    // [236] phi utoa::started#2 = utoa::started#4 [phi:utoa::@4->utoa::@1#1] -- register_copy 
    // [236] phi utoa::value#2 = utoa::value#6 [phi:utoa::@4->utoa::@1#2] -- register_copy 
    // [236] phi utoa::digit#2 = utoa::digit#1 [phi:utoa::@4->utoa::@1#3] -- register_copy 
    jmp __b1
    // utoa::@5
  __b5:
    // utoa_append(buffer++, value, digit_value)
    // [249] utoa_append::buffer#0 = utoa::buffer#11 -- pbuz1=pbuz2 
    lda.z buffer
    sta.z utoa_append.buffer
    lda.z buffer+1
    sta.z utoa_append.buffer+1
    // [250] utoa_append::value#0 = utoa::value#2
    // [251] utoa_append::sub#0 = utoa::digit_value#0
    // [252] call utoa_append
    // [311] phi from utoa::@5 to utoa_append [phi:utoa::@5->utoa_append]
    jsr utoa_append
    // utoa_append(buffer++, value, digit_value)
    // [253] utoa_append::return#0 = utoa_append::value#2
    // utoa::@6
    // value = utoa_append(buffer++, value, digit_value)
    // [254] utoa::value#0 = utoa_append::return#0
    // value = utoa_append(buffer++, value, digit_value);
    // [255] utoa::buffer#4 = ++ utoa::buffer#11 -- pbuz1=_inc_pbuz1 
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    // [247] phi from utoa::@6 to utoa::@4 [phi:utoa::@6->utoa::@4]
    // [247] phi utoa::buffer#14 = utoa::buffer#4 [phi:utoa::@6->utoa::@4#0] -- register_copy 
    // [247] phi utoa::started#4 = 1 [phi:utoa::@6->utoa::@4#1] -- vbuz1=vbuc1 
    lda #1
    sta.z started
    // [247] phi utoa::value#6 = utoa::value#0 [phi:utoa::@6->utoa::@4#2] -- register_copy 
    jmp __b4
}
  // printf_number_buffer
// Print the contents of the number buffer using a specific format.
// This handles minimum length, zero-filling, and left/right justification from the format
// void printf_number_buffer(void (*putc)(char), __zp($4f) char buffer_sign, char *buffer_digits, char format_min_length, char format_justify_left, char format_sign_always, char format_zero_padding, char format_upper_case, char format_radix)
printf_number_buffer: {
    .const format_min_length = 3
    .label buffer_digits = printf_buffer+OFFSET_STRUCT_PRINTF_BUFFER_NUMBER_DIGITS
    .label putc = cputc
    .label __19 = $47
    .label buffer_sign = $4f
    .label len = $38
    .label padding = $38
    // [257] phi from printf_number_buffer to printf_number_buffer::@4 [phi:printf_number_buffer->printf_number_buffer::@4]
    // printf_number_buffer::@4
    // strlen(buffer.digits)
    // [258] call strlen
    // [318] phi from printf_number_buffer::@4 to strlen [phi:printf_number_buffer::@4->strlen]
    jsr strlen
    // strlen(buffer.digits)
    // [259] strlen::return#2 = strlen::len#2
    // printf_number_buffer::@9
    // [260] printf_number_buffer::$19 = strlen::return#2
    // signed char len = (signed char)strlen(buffer.digits)
    // [261] printf_number_buffer::len#0 = (signed char)printf_number_buffer::$19 -- vbsz1=_sbyte_vwuz2 
    // There is a minimum length - work out the padding
    lda.z __19
    sta.z len
    // if(buffer.sign)
    // [262] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@8 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    beq __b8
    // printf_number_buffer::@5
    // len++;
    // [263] printf_number_buffer::len#1 = ++ printf_number_buffer::len#0 -- vbsz1=_inc_vbsz1 
    inc.z len
    // [264] phi from printf_number_buffer::@5 printf_number_buffer::@9 to printf_number_buffer::@8 [phi:printf_number_buffer::@5/printf_number_buffer::@9->printf_number_buffer::@8]
    // [264] phi printf_number_buffer::len#2 = printf_number_buffer::len#1 [phi:printf_number_buffer::@5/printf_number_buffer::@9->printf_number_buffer::@8#0] -- register_copy 
    // printf_number_buffer::@8
  __b8:
    // padding = (signed char)format.min_length - len
    // [265] printf_number_buffer::padding#1 = (signed char)printf_number_buffer::format_min_length#0 - printf_number_buffer::len#2 -- vbsz1=vbsc1_minus_vbsz1 
    lda #format_min_length
    sec
    sbc.z padding
    sta.z padding
    // if(padding<0)
    // [266] if(printf_number_buffer::padding#1>=0) goto printf_number_buffer::@11 -- vbsz1_ge_0_then_la1 
    cmp #0
    bpl __b2
    // [268] phi from printf_number_buffer::@8 to printf_number_buffer::@1 [phi:printf_number_buffer::@8->printf_number_buffer::@1]
    // [268] phi printf_number_buffer::padding#10 = 0 [phi:printf_number_buffer::@8->printf_number_buffer::@1#0] -- vbsz1=vbsc1 
    lda #0
    sta.z padding
    // [267] phi from printf_number_buffer::@8 to printf_number_buffer::@11 [phi:printf_number_buffer::@8->printf_number_buffer::@11]
    // printf_number_buffer::@11
    // [268] phi from printf_number_buffer::@11 to printf_number_buffer::@1 [phi:printf_number_buffer::@11->printf_number_buffer::@1]
    // [268] phi printf_number_buffer::padding#10 = printf_number_buffer::padding#1 [phi:printf_number_buffer::@11->printf_number_buffer::@1#0] -- register_copy 
    // printf_number_buffer::@1
    // printf_number_buffer::@2
  __b2:
    // if(buffer.sign)
    // [269] if(0==printf_number_buffer::buffer_sign#0) goto printf_number_buffer::@10 -- 0_eq_vbuz1_then_la1 
    lda.z buffer_sign
    beq __b10
    // printf_number_buffer::@6
    // putc(buffer.sign)
    // [270] stackpush(char) = printf_number_buffer::buffer_sign#0 -- _stackpushbyte_=vbuz1 
    pha
    // [271] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_number_buffer::@10
  __b10:
    // if(format.zero_padding && padding)
    // [273] if(0!=printf_number_buffer::padding#10) goto printf_number_buffer::@7 -- 0_neq_vbsz1_then_la1 
    lda.z padding
    cmp #0
    bne __b7
    // [276] phi from printf_number_buffer::@10 printf_number_buffer::@7 to printf_number_buffer::@3 [phi:printf_number_buffer::@10/printf_number_buffer::@7->printf_number_buffer::@3]
    jmp __b3
    // printf_number_buffer::@7
  __b7:
    // printf_padding(putc, '0',(char)padding)
    // [274] printf_padding::length#1 = (char)printf_number_buffer::padding#10 -- vbuz1=vbuz2 
    lda.z padding
    sta.z printf_padding.length
    // [275] call printf_padding
    // [324] phi from printf_number_buffer::@7 to printf_padding [phi:printf_number_buffer::@7->printf_padding]
    jsr printf_padding
    // printf_number_buffer::@3
  __b3:
    // printf_str(putc, buffer.digits)
    // [277] call printf_str
    // [192] phi from printf_number_buffer::@3 to printf_str [phi:printf_number_buffer::@3->printf_str]
    // [192] phi printf_str::putc#6 = printf_number_buffer::putc#0 [phi:printf_number_buffer::@3->printf_str#0] -- pprz1=pprc1 
    lda #<putc
    sta.z printf_str.putc
    lda #>putc
    sta.z printf_str.putc+1
    // [192] phi printf_str::s#6 = printf_number_buffer::buffer_digits#0 [phi:printf_number_buffer::@3->printf_str#1] -- pbuz1=pbuc1 
    lda #<buffer_digits
    sta.z printf_str.s
    lda #>buffer_digits
    sta.z printf_str.s+1
    jsr printf_str
    // printf_number_buffer::@return
    // }
    // [278] return 
    rts
}
  // insertup
// Insert a new line, and scroll the upper part of the screen up.
insertup: {
    .label __3 = $2f
    .label cy = $31
    .label width = $30
    .label line = $2a
    .label start = $2a
    .label i = $2e
    // unsigned char cy = __conio.cursor_y
    // [279] insertup::cy#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y) -- vbuz1=_deref_pbuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_Y
    sta.z cy
    // unsigned char width = __conio.width * 2
    // [280] insertup::width#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH) << 1 -- vbuz1=_deref_pbuc1_rol_1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    asl
    sta.z width
    // [281] phi from insertup to insertup::@1 [phi:insertup->insertup::@1]
    // [281] phi insertup::i#2 = 1 [phi:insertup->insertup::@1#0] -- vbuz1=vbuc1 
    lda #1
    sta.z i
    // insertup::@1
  __b1:
    // for(unsigned char i=1; i<=cy; i++)
    // [282] if(insertup::i#2<=insertup::cy#0) goto insertup::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z cy
    cmp.z i
    bcs __b2
    // [283] phi from insertup::@1 to insertup::@3 [phi:insertup::@1->insertup::@3]
    // insertup::@3
    // clearline()
    // [284] call clearline
    jsr clearline
    // insertup::@return
    // }
    // [285] return 
    rts
    // insertup::@2
  __b2:
    // i-1
    // [286] insertup::$3 = insertup::i#2 - 1 -- vbuz1=vbuz2_minus_1 
    ldx.z i
    dex
    stx.z __3
    // unsigned int line = (i-1) << __conio.rowshift
    // [287] insertup::line#0 = insertup::$3 << *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT) -- vwuz1=vbuz2_rol__deref_pbuc1 
    txa
    ldy __conio+OFFSET_STRUCT_CX16_CONIO_ROWSHIFT
    sta.z line
    lda #0
    sta.z line+1
    cpy #0
    beq !e+
  !:
    asl.z line
    rol.z line+1
    dey
    bne !-
  !e:
    // unsigned int start = __conio.mapbase_offset + line
    // [288] insertup::start#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) + insertup::line#0 -- vwuz1=_deref_pwuc1_plus_vwuz1 
    clc
    lda.z start
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z start
    lda.z start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z start+1
    // memcpy_vram_vram_inc(0, start, VERA_INC_1, 0, start+__conio.rowskip, VERA_INC_1, width)
    // [289] memcpy_vram_vram_inc::soffset_vram#0 = insertup::start#0 + *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP) -- vwuz1=vwuz2_plus__deref_pwuc1 
    lda.z start
    clc
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP
    sta.z memcpy_vram_vram_inc.soffset_vram
    lda.z start+1
    adc __conio+OFFSET_STRUCT_CX16_CONIO_ROWSKIP+1
    sta.z memcpy_vram_vram_inc.soffset_vram+1
    // [290] memcpy_vram_vram_inc::doffset_vram#0 = insertup::start#0
    // [291] memcpy_vram_vram_inc::num#0 = insertup::width#0 -- vwuz1=vbuz2 
    lda.z width
    sta.z memcpy_vram_vram_inc.num
    lda #0
    sta.z memcpy_vram_vram_inc.num+1
    // [292] call memcpy_vram_vram_inc
    // [332] phi from insertup::@2 to memcpy_vram_vram_inc [phi:insertup::@2->memcpy_vram_vram_inc]
    jsr memcpy_vram_vram_inc
    // insertup::@4
    // for(unsigned char i=1; i<=cy; i++)
    // [293] insertup::i#1 = ++ insertup::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [281] phi from insertup::@4 to insertup::@1 [phi:insertup::@4->insertup::@1]
    // [281] phi insertup::i#2 = insertup::i#1 [phi:insertup::@4->insertup::@1#0] -- register_copy 
    jmp __b1
}
  // clearline
clearline: {
    .label __1 = $27
    .label __2 = $28
    .label mapbase_offset = $2c
    .label conio_line = $24
    .label addr = $2c
    .label color = $26
    .label c = $22
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [294] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // unsigned int mapbase_offset =  (unsigned int)__conio.mapbase_offset
    // [295] clearline::mapbase_offset#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET) -- vwuz1=_deref_pwuc1 
    // Set address
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET
    sta.z mapbase_offset
    lda __conio+OFFSET_STRUCT_CX16_CONIO_MAPBASE_OFFSET+1
    sta.z mapbase_offset+1
    // unsigned int conio_line = __conio.line
    // [296] clearline::conio_line#0 = *((unsigned int *)&__conio+OFFSET_STRUCT_CX16_CONIO_LINE) -- vwuz1=_deref_pwuc1 
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE
    sta.z conio_line
    lda __conio+OFFSET_STRUCT_CX16_CONIO_LINE+1
    sta.z conio_line+1
    // mapbase_offset + conio_line
    // [297] clearline::addr#0 = clearline::mapbase_offset#0 + clearline::conio_line#0 -- vwuz1=vwuz1_plus_vwuz2 
    clc
    lda.z addr
    adc.z conio_line
    sta.z addr
    lda.z addr+1
    adc.z conio_line+1
    sta.z addr+1
    // BYTE0(addr)
    // [298] clearline::$1 = byte0  (char *)clearline::addr#0 -- vbuz1=_byte0_pbuz2 
    lda.z addr
    sta.z __1
    // *VERA_ADDRX_L = BYTE0(addr)
    // [299] *VERA_ADDRX_L = clearline::$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(addr)
    // [300] clearline::$2 = byte1  (char *)clearline::addr#0 -- vbuz1=_byte1_pbuz2 
    lda.z addr+1
    sta.z __2
    // *VERA_ADDRX_M = BYTE1(addr)
    // [301] *VERA_ADDRX_M = clearline::$2 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = VERA_INC_1
    // [302] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // char color = __conio.color
    // [303] clearline::color#0 = *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_COLOR) -- vbuz1=_deref_pbuc1 
    // TODO need to check this!
    lda __conio+OFFSET_STRUCT_CX16_CONIO_COLOR
    sta.z color
    // [304] phi from clearline to clearline::@1 [phi:clearline->clearline::@1]
    // [304] phi clearline::c#2 = 0 [phi:clearline->clearline::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z c
    sta.z c+1
    // clearline::@1
  __b1:
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [305] if(clearline::c#2<*((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_WIDTH)) goto clearline::@2 -- vwuz1_lt__deref_pbuc1_then_la1 
    lda.z c+1
    bne !+
    lda.z c
    cmp __conio+OFFSET_STRUCT_CX16_CONIO_WIDTH
    bcc __b2
  !:
    // clearline::@3
    // __conio.cursor_x = 0
    // [306] *((char *)&__conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X) = 0 -- _deref_pbuc1=vbuc2 
    lda #0
    sta __conio+OFFSET_STRUCT_CX16_CONIO_CURSOR_X
    // clearline::@return
    // }
    // [307] return 
    rts
    // clearline::@2
  __b2:
    // *VERA_DATA0 = ' '
    // [308] *VERA_DATA0 = ' ' -- _deref_pbuc1=vbuc2 
    // Set data
    lda #' '
    sta VERA_DATA0
    // *VERA_DATA0 = color
    // [309] *VERA_DATA0 = clearline::color#0 -- _deref_pbuc1=vbuz1 
    lda.z color
    sta VERA_DATA0
    // for( unsigned int c=0;c<__conio.width; c++ )
    // [310] clearline::c#1 = ++ clearline::c#2 -- vwuz1=_inc_vwuz1 
    inc.z c
    bne !+
    inc.z c+1
  !:
    // [304] phi from clearline::@2 to clearline::@1 [phi:clearline::@2->clearline::@1]
    // [304] phi clearline::c#2 = clearline::c#1 [phi:clearline::@2->clearline::@1#0] -- register_copy 
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
// __zp($36) unsigned int utoa_append(__zp($47) char *buffer, __zp($36) unsigned int value, __zp($3b) unsigned int sub)
utoa_append: {
    .label buffer = $47
    .label value = $36
    .label sub = $3b
    .label return = $36
    .label digit = $38
    // [312] phi from utoa_append to utoa_append::@1 [phi:utoa_append->utoa_append::@1]
    // [312] phi utoa_append::digit#2 = 0 [phi:utoa_append->utoa_append::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z digit
    // [312] phi utoa_append::value#2 = utoa_append::value#0 [phi:utoa_append->utoa_append::@1#1] -- register_copy 
    // utoa_append::@1
  __b1:
    // while (value >= sub)
    // [313] if(utoa_append::value#2>=utoa_append::sub#0) goto utoa_append::@2 -- vwuz1_ge_vwuz2_then_la1 
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
    // [314] *utoa_append::buffer#0 = DIGITS[utoa_append::digit#2] -- _deref_pbuz1=pbuc1_derefidx_vbuz2 
    ldy.z digit
    lda DIGITS,y
    ldy #0
    sta (buffer),y
    // utoa_append::@return
    // }
    // [315] return 
    rts
    // utoa_append::@2
  __b2:
    // digit++;
    // [316] utoa_append::digit#1 = ++ utoa_append::digit#2 -- vbuz1=_inc_vbuz1 
    inc.z digit
    // value -= sub
    // [317] utoa_append::value#1 = utoa_append::value#2 - utoa_append::sub#0 -- vwuz1=vwuz1_minus_vwuz2 
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    // [312] phi from utoa_append::@2 to utoa_append::@1 [phi:utoa_append::@2->utoa_append::@1]
    // [312] phi utoa_append::digit#2 = utoa_append::digit#1 [phi:utoa_append::@2->utoa_append::@1#0] -- register_copy 
    // [312] phi utoa_append::value#2 = utoa_append::value#1 [phi:utoa_append::@2->utoa_append::@1#1] -- register_copy 
    jmp __b1
}
  // strlen
// Computes the length of the string str up to but not including the terminating null character.
// __zp($47) unsigned int strlen(__zp($44) char *str)
strlen: {
    .label len = $47
    .label str = $44
    .label return = $47
    // [319] phi from strlen to strlen::@1 [phi:strlen->strlen::@1]
    // [319] phi strlen::len#2 = 0 [phi:strlen->strlen::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z len
    sta.z len+1
    // [319] phi strlen::str#2 = printf_number_buffer::buffer_digits#0 [phi:strlen->strlen::@1#1] -- pbuz1=pbuc1 
    lda #<printf_number_buffer.buffer_digits
    sta.z str
    lda #>printf_number_buffer.buffer_digits
    sta.z str+1
    // strlen::@1
  __b1:
    // while(*str)
    // [320] if(0!=*strlen::str#2) goto strlen::@2 -- 0_neq__deref_pbuz1_then_la1 
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // strlen::@return
    // }
    // [321] return 
    rts
    // strlen::@2
  __b2:
    // len++;
    // [322] strlen::len#1 = ++ strlen::len#2 -- vwuz1=_inc_vwuz1 
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    // [323] strlen::str#0 = ++ strlen::str#2 -- pbuz1=_inc_pbuz1 
    inc.z str
    bne !+
    inc.z str+1
  !:
    // [319] phi from strlen::@2 to strlen::@1 [phi:strlen::@2->strlen::@1]
    // [319] phi strlen::len#2 = strlen::len#1 [phi:strlen::@2->strlen::@1#0] -- register_copy 
    // [319] phi strlen::str#2 = strlen::str#0 [phi:strlen::@2->strlen::@1#1] -- register_copy 
    jmp __b1
}
  // printf_padding
// Print a padding char a number of times
// void printf_padding(void (*putc)(char), char pad, __zp($4a) char length)
printf_padding: {
    .label i = $46
    .label length = $4a
    // [325] phi from printf_padding to printf_padding::@1 [phi:printf_padding->printf_padding::@1]
    // [325] phi printf_padding::i#2 = 0 [phi:printf_padding->printf_padding::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z i
    // printf_padding::@1
  __b1:
    // for(char i=0;i<length; i++)
    // [326] if(printf_padding::i#2<printf_padding::length#1) goto printf_padding::@2 -- vbuz1_lt_vbuz2_then_la1 
    lda.z i
    cmp.z length
    bcc __b2
    // printf_padding::@return
    // }
    // [327] return 
    rts
    // printf_padding::@2
  __b2:
    // putc(pad)
    // [328] stackpush(char) = '0' -- _stackpushbyte_=vbuc1 
    lda #'0'
    pha
    // [329] callexecute cputc  -- call_vprc1 
    jsr cputc
    // sideeffect stackpullpadding(1) -- _stackpullpadding_1 
    pla
    // printf_padding::@3
    // for(char i=0;i<length; i++)
    // [331] printf_padding::i#1 = ++ printf_padding::i#2 -- vbuz1=_inc_vbuz1 
    inc.z i
    // [325] phi from printf_padding::@3 to printf_padding::@1 [phi:printf_padding::@3->printf_padding::@1]
    // [325] phi printf_padding::i#2 = printf_padding::i#1 [phi:printf_padding::@3->printf_padding::@1#0] -- register_copy 
    jmp __b1
}
  // memcpy_vram_vram_inc
/**
 * @brief Copy block of memory from vram to vram with specified vera increments/decrements.
 * Copies num bytes from the source vram bank/offset to the destination vram bank/offset, with specified increment/decrement.
 *
 * @param dbank_vram Destination vram bank.
 * @param doffset_vram Destination vram offset.
 * @param dinc Destination vram increment/decrement.
 * @param sbank_vram Source vram bank.
 * @param soffset_vram Source vram offset.
 * @param sinc Source vram increment/decrement.
 * @param num Amount of bytes to copy.
 */
// void memcpy_vram_vram_inc(char dbank_vram, __zp($2a) unsigned int doffset_vram, char dinc, char sbank_vram, __zp($2c) unsigned int soffset_vram, char sinc, __zp($24) unsigned int num)
memcpy_vram_vram_inc: {
    .label vera_vram_data0_bank_offset1___0 = $27
    .label vera_vram_data0_bank_offset1___1 = $28
    .label vera_vram_data1_bank_offset1___0 = $26
    .label vera_vram_data1_bank_offset1___1 = $29
    .label i = $22
    .label doffset_vram = $2a
    .label soffset_vram = $2c
    .label num = $24
    // memcpy_vram_vram_inc::vera_vram_data0_bank_offset1
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // [333] *VERA_CTRL = *VERA_CTRL & ~VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [334] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::soffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z soffset_vram
    sta.z vera_vram_data0_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [335] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [336] memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::soffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z soffset_vram+1
    sta.z vera_vram_data0_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [337] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data0_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [338] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // memcpy_vram_vram_inc::vera_vram_data1_bank_offset1
    // *VERA_CTRL |= VERA_ADDRSEL
    // [339] *VERA_CTRL = *VERA_CTRL | VERA_ADDRSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_ADDRSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // BYTE0(offset)
    // [340] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 = byte0  memcpy_vram_vram_inc::doffset_vram#0 -- vbuz1=_byte0_vwuz2 
    lda.z doffset_vram
    sta.z vera_vram_data1_bank_offset1___0
    // *VERA_ADDRX_L = BYTE0(offset)
    // [341] *VERA_ADDRX_L = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$0 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_L
    // BYTE1(offset)
    // [342] memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 = byte1  memcpy_vram_vram_inc::doffset_vram#0 -- vbuz1=_byte1_vwuz2 
    lda.z doffset_vram+1
    sta.z vera_vram_data1_bank_offset1___1
    // *VERA_ADDRX_M = BYTE1(offset)
    // [343] *VERA_ADDRX_M = memcpy_vram_vram_inc::vera_vram_data1_bank_offset1_$1 -- _deref_pbuc1=vbuz1 
    sta VERA_ADDRX_M
    // *VERA_ADDRX_H = bank | inc_dec
    // [344] *VERA_ADDRX_H = VERA_INC_1 -- _deref_pbuc1=vbuc2 
    lda #VERA_INC_1
    sta VERA_ADDRX_H
    // [345] phi from memcpy_vram_vram_inc::vera_vram_data1_bank_offset1 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1]
    // [345] phi memcpy_vram_vram_inc::i#2 = 0 [phi:memcpy_vram_vram_inc::vera_vram_data1_bank_offset1->memcpy_vram_vram_inc::@1#0] -- vwuz1=vwuc1 
    lda #<0
    sta.z i
    sta.z i+1
  // Transfer the data
    // memcpy_vram_vram_inc::@1
  __b1:
    // for(unsigned int i=0; i<num; i++)
    // [346] if(memcpy_vram_vram_inc::i#2<memcpy_vram_vram_inc::num#0) goto memcpy_vram_vram_inc::@2 -- vwuz1_lt_vwuz2_then_la1 
    lda.z i+1
    cmp.z num+1
    bcc __b2
    bne !+
    lda.z i
    cmp.z num
    bcc __b2
  !:
    // memcpy_vram_vram_inc::@return
    // }
    // [347] return 
    rts
    // memcpy_vram_vram_inc::@2
  __b2:
    // *VERA_DATA1 = *VERA_DATA0
    // [348] *VERA_DATA1 = *VERA_DATA0 -- _deref_pbuc1=_deref_pbuc2 
    lda VERA_DATA0
    sta VERA_DATA1
    // for(unsigned int i=0; i<num; i++)
    // [349] memcpy_vram_vram_inc::i#1 = ++ memcpy_vram_vram_inc::i#2 -- vwuz1=_inc_vwuz1 
    inc.z i
    bne !+
    inc.z i+1
  !:
    // [345] phi from memcpy_vram_vram_inc::@2 to memcpy_vram_vram_inc::@1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1]
    // [345] phi memcpy_vram_vram_inc::i#2 = memcpy_vram_vram_inc::i#1 [phi:memcpy_vram_vram_inc::@2->memcpy_vram_vram_inc::@1#0] -- register_copy 
    jmp __b1
}
  // File Data
.segment Data
  VERA_LAYER_WIDTH: .word $20, $40, $80, $100
  VERA_LAYER_HEIGHT: .word $20, $40, $80, $100
  VERA_LAYER_SKIP: .word $40, $80, $100, $200
  // The digits used for numbers
  DIGITS: .text "0123456789abcdef"
  // Values of decimal digits
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
  __conio: .fill SIZEOF_STRUCT_CX16_CONIO, 0
  // Buffer used for stringified number being printed
  printf_buffer: .fill SIZEOF_STRUCT_PRINTF_BUFFER_NUMBER, 0

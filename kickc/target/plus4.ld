// Commodore 16 / Plus/4 executable PRG file
.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$1001]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
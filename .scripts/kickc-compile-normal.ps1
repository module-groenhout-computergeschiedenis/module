& "./.scripts/kickc-config.ps1" $args[0] $args[1] $args[2] $args[3]

# Unoptimized compile
java -Xms512M -Xmx1024M -jar "$kickc_jar"  $target -I "$kickc_stdinclude" -L "$kickc_stdlib"   -F "$kickc_fragment_home" -P "$kickc_platform_home" -a -Sc -Si -v  -Onouplift -Xassembler=-showmem -Xassembler=-symbolfile -odir "$workspacedir/$dir/../target" "$workspacedir/$dir/$file"


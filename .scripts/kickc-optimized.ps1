& "./.scripts/kickc-config.ps1" $args[0] $args[1] $args[2] $args[3]


# Optimized compile
#java -jar "$kickc_jar" -I "$user_include" -I "$kickc_stdinclude" -L "$user_lib" -L "$kickc_stdlib"   -F "$kickc_fragment_home" -P "$kickc_platform_home" -t=cx16 -a -Sc -Si -v  -Ocoalesce -Xassembler=-symbolfile -odir "$workspacedir/$dir/../target" "$workspacedir/$dir/$file"

java -jar "$kickc_jar" $target -I "$user_include" -I "$kickc_stdinclude" -L "$user_lib" -L "$kickc_stdlib"   -F "$kickc_fragment_home" -P "$kickc_platform_home" -Ouplift=10 -a -Sc -Si -v -Xassembler=-symbolfile -odir "$workspacedir/$dir/../target" "$workspacedir/$dir/$file"

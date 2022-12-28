& "./.scripts/kickc-config.ps1" $args[0] $args[1] $args[2] $args[3]


java -jar "$kickc_jar" $target -I "$kickc_stdinclude" -L "$kickc_stdlib"   -F "$kickc_fragment_home" -P "$kickc_platform_home" -Ouplift=10 -a -Sc -Si -v -Xassembler=-symbolfile -odir "$workspacedir/$dir/../target" "$workspacedir/$dir/$file"

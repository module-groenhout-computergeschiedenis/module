echo $args[0] $args[1] $args[2]
$workspacedir=$args[0]
$dir=$args[1]
$file=$args[2]
$emulator=$args[3]

if($emulator -eq "box16") {
    box16 -echo -nopatch -sym "$workspacedir/$dir/$file.vs" -vsync none -keymap fr-be -prg $workspacedir/$dir/../target/$file.prg -run
}
elseif ($emulator -eq "xpet") {
    cd "$workspacedir/vice"
    xpet "$workspacedir/$dir/../target/$file.prg"
}
elseif ($emulator -eq "x64sc") {
    cd "$workspacedir/vice"
    x64sc "$workspacedir/$dir/../target/$file.prg"
}

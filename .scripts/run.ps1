echo $args[0] $args[1] $args[2]
$workspacedir=$args[0]
$dir=$args[1]
$file=$args[2]
$emulator=$args[3]

if ($emulator -eq "PET8032") {
    cd "$workspacedir/vice/bin"
    xpet "$workspacedir/$dir/../target/$file.prg"
}
elseif ($emulator -eq "C64") {
    cd "$workspacedir/vice/bin"
    x64sc "$workspacedir/$dir/../target/$file.prg"
}
elseif ($emulator -eq "C128") {
    cd "$workspacedir/vice/bin"
    x128 "$workspacedir/$dir/../target/$file.prg"
}

echo $args[0] $args[1] $args[2]
$workspacedir=$args[0]
$dir=$args[1]
$file=$args[2]
$emulator=$args[3]

if ($emulator -eq "PET8032") {
    cd "$workspacedir/vice/bin"
    xpet 
}
elseif ($emulator -eq "C64") {
    cd "$workspacedir/vice/bin"
    x64sc 
}
elseif ($emulator -eq "C128") {
    cd "$workspacedir/vice/bin"
    x128 
}

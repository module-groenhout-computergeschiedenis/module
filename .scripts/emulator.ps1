echo $args[0] $args[1] $args[2]
$workspacedir=$args[0]
$dir=$args[1]
$file=$args[2]
$emulator=$args[3]

if ($emulator -eq "PET8032") {
    . "$workspacedir/vice/bin/xpet.exe" 
}
elseif ($emulator -eq "C64") {
    . "$workspacedir/vice/bin/x64sc.exe" 
}
elseif ($emulator -eq "C128") {
    . "$workspacedir/vice/bin/x128.exe" 
}

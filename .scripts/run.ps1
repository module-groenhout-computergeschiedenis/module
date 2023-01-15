echo $args[0] $args[1] $args[2]
$workspacedir=$args[0]
$dir=$args[1]
$file=$args[2]
$emulator=$args[3]

if ($emulator -eq "PET8032") {
    Write-Output "$workspacedir/vice/bin/xpet.exe" "$workspacedir/$dir/../target/$file.prg"
    & "$workspacedir/vice/bin/xpet.exe" "$workspacedir/$dir/../target/$file.prg"
}
elseif ($emulator -eq "C64") {
    Write-Output "$workspacedir/vice/bin/x64sc.exe" "$workspacedir/$dir/../target/$file.prg" 
    & "$workspacedir/vice/bin/x64sc.exe" "$workspacedir/$dir/../target/$file.prg"
}
elseif ($emulator -eq "C128") {
    Write-Output "$workspacedir/vice/bin/x128.exe" "$workspacedir/$dir/../target/$file.prg"
    & "$workspacedir/vice/bin/x128.exe" "$workspacedir/$dir/../target/$file.prg" # +trace_maincpu 
}

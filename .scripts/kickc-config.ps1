$global:workspacedir=$args[0]
$global:dir=$args[1]
$global:file=$args[2]
$global:target=$args[3]

Write-Output('$workspacedir = ' + $global:workspacedir)
Write-Output('$global:dir = ' + $global:dir)
Write-Output('$global:file = ' + $global:file)
Write-Output('$global:target = ' + $global:target)


$global:kickc = $global:workspacedir + "\kickc"

$global:kickc_stdlib = ($kickc + "\lib")
$global:kickc_stdinclude = ($kickc + "\include")
$global:kickc_fragment_home = ($kickc + "\fragment")
$global:kickc_platform_home = ($kickc + "\target")
$global:kickc_jar = ($kickc + "\jar\kickc-release.jar")

Write-Output ("kickc = " + $kickc)
Write-Output ("kickc_dev = " + $kickc_dev)
Write-Output ("kickc_stdinclude = " + $kickc_stdinclude)
Write-Output ("kickc_stdlib = " + $kickc_stdlib)
Write-Output ("kickc_fragment_home = " + $kickc_fragment_home)
Write-Output ("kickc_platform_home = " + $kickc_platform_home)
Write-Output ("kickc_jar = " + $kickc_jar)

cd (Get-Location).Path
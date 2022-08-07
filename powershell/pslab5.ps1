# getting parameters from command line/terminal
param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)
# If no parameter is passed in the command line/terminal
if ( !($System) -and !($Disks) -and !($Network)) {
    hdInfo
    processorInfo
    osInfo
    ramInfo
    videoInfo
    diskInfo
    nwInfo
}
# If -system paramenter is passed on command line/terminal
if ($System) {
    hdInfo
    processorInfo
    osInfo
    ramInfo
    videoInfo
}
# If -disks paramenter is passed on command line/terminal
if ($Disks) {
    diskInfo
}
# If -network paramenter is passed on command line/terminal
if ($Network) {
    nwInfo
}
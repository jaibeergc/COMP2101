function hdInfo {
    echo "+++++++++++ Hardware Description +++++++++++"
    gwmi win32_computersystem | fl Domain, Manufacturer, Model, Name, TotalPhysicalMemory
    echo "++++++++++++++++++++++++++++++++++++++++++++"
}
function osInfo {
    echo "+++++++++++ OS Information +++++++++++"
    gwmi win32_operatingsystem | select Caption, Version, OSArchitecture | fl
    echo "++++++++++++++++++++++++++++++++++++++"
}

function processorInfo {
    echo "+++++++++++ Processor Information +++++++++++"
    gwmi win32_processor |
    select Name, NumberOfCores, CurrectClockSpeed, MaxClockSpeed,
    @{
        n = "L1CacheSize";
        e = {
            switch ($_.L1CacheSize) {
                $null { $data = "data unavailable" }
                Default { $data = $_.L1CacheSize }
            };
            $data
        }
    },
    @{
        n = "L2CacheSize";
        e = {
            switch ($_.L2CacheSize) {
                $null { $data = "data unavailable" }
                Default { $data = $_.L2CacheSize }
            };
            $data
        }
    },
    @{
        n = "L3CacheSize";
        e = {
            switch ($_.L3CacheSize) {
                $null { $data = "data unavailable" }
                Default { $data = $_.L3CacheSize }
            };
            $data
        }
    } | fl
    echo "+++++++++++++++++++++++++++++++++++++++++++++"
}

function ramInfo {
    echo "+++++++++++ RAM Information +++++++++++"
    $tram = 0
    gwmi win32_physicalmemory |
    Foreach-Object {
        $curRam = $_ ;
        New-Object -TypeName psObject -Property @{
            Manufacturer = $curRam.Manufacturer
            Description  = $curRam.Description
            "Size(gb)"   = $curRam.Capacity / 1gb
            Bank         = $curRam.banklabel
            Slot         = $curRam.devicelocator
        }
        $tram += $curRam.Capacity / 1gb
    } |
    ft -autosize Manufacturer, Description, "Size(gb)", Bank, Slot
    echo "Total Ram (GB): $($tram)"
    echo "+++++++++++++++++++++++++++++++++++++++"
}

function diskInfo {
    echo "+++++++++++ Physical Disk Information +++++++++++"
    $diskdrives = Get-CIMInstance CIM_diskdrive | where DeviceID -ne $null

    foreach ($disk in $diskdrives) {
        $partitions = $disk | get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                new-object -typename psobject -property @{
                    Model          = $disk.Model
                    Manufacturer   = $disk.Manufacturer
                    Location       = $partition.deviceid
                    Drive          = $logicaldisk.deviceid
                    "Size(GB)"     = [string]($logicaldisk.size / 1gb -as [int]) + "gb"
                    FreeSpace      = [string]($logicaldisk.FreeSpace / 1gb -as [int]) + "gb"
                    "FreeSpace(%)" = [string]((($logicaldisk.FreeSpace / $logicaldisk.size) * 100) -as [int]) + "%"
                } | ft -AutoSize
            }
        }
    }
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++"
}

function nwInfo {
    echo "+++++++++++ Network Adapter Information +++++++++++"
    get-ciminstance win32_networkadapterconfiguration |
    where { $_.IPEnabled -eq $True } |
    ft Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder -AutoSize
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++"
}

function videoInfo {
    echo "+++++++++++ Video Information +++++++++++"
    $video = gwmi win32_videocontroller
    $info = New-Object -TypeName psObject -Property @{
        Name             = $video.Name
        Description      = $video.Description
        ScreenResolution = [string]($video.CurrentHorizontalResolution) + 'px X ' + [string] ($video.CurrentVerticalResolution) + "px"
    } |
    fl Name, Description, ScreenResolution
    $info
    echo "+++++++++++++++++++++++++++++++++++++++++"
}

$check_interval_milliseconds = 500

$default_gw = (Get-NetRoute |
    Where-Object { $_.DestinationPrefix -eq "0.0.0.0/0" } |
    Sort-Object RouteMetric |
    Select-Object -First 1 -ExpandProperty NextHop)

if (-not $default_gw) {
    Write-Host "Error: Could not auto-detect default gateway." -ForegroundColor Red
    exit 1
}

$known_mac = $null
$attempt   = 0

while ($true) {
    $attempt++

    # Populate ARP cache
    $null = Test-Connection -ComputerName $default_gw -Count 1 -Quiet -ErrorAction SilentlyContinue
    $arp_line = arp -a $default_gw 2>$null

    $current_mac = $null
    if ($arp_line) {
        $m = [regex]::Match($arp_line, '([0-9a-fA-F\-]{17})')
        if ($m.Success) {
            $current_mac = ($m.Groups[1].Value -replace '-', ':').ToLower()
        }
    }

    # Record baseline as soon as we successfully see a MAC
    if (-not $known_mac -and $current_mac) {
        $known_mac = $current_mac
    }

    Clear-Host
    Write-Host "Monitoring default gateway: $default_gw" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop`n"

    if ($known_mac) {
        Write-Host "Baseline gateway MAC: $known_mac" -ForegroundColor Green
    } else {
        Write-Host "Baseline gateway MAC: (not recorded yet)" -ForegroundColor Yellow
    }

    if (-not $current_mac) {
        Write-Host "[Attempt: $attempt] No ARP entry for $default_gw yet..." -ForegroundColor Yellow
    }
    elseif ($current_mac -ne $known_mac) {
        Clear-Host
        Write-Host "`n!!! GATEWAY MAC CHANGED - POSSIBLE ROGUE GATEWAY !!!" -ForegroundColor Red -BackgroundColor Black
        Write-Host ""
        Write-Host "Default gateway: $default_gw"
        Write-Host "Old baseline MAC: $known_mac"
        Write-Host "New current MAC : $current_mac"
        Write-Host "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        Write-Host ""

        [console]::beep(1000, 700)

        break
    }
    else {
        Write-Host "[Attempt: $attempt] OK (Current MAC: $current_mac)" -ForegroundColor DarkGray
    }

    Start-Sleep -MilliSeconds $check_interval_milliseconds
}

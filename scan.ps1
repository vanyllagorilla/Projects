$unsecure_ports = @(21, 22, 23, 25, 53, 80, 110, 123, 137, 138, 139, 143, 161, 389, 443, 445, 587, 636, 993, 995, 1723, 3306, 3389)
$ESXhost = "127.0.0.1" # default host

Function Check-Port {
    Param (
        [string]$ESXHost,
        [int]$port
    )

    $socket = New-Object System.Net.Sockets.TcpClient
    $socket.ReceiveTimeout = 5000

    try {
        $socket.Connect($ESXHost, $port)
        $socket.Connected
    } catch {
        $false
    } finally {
        $socket.Close()
    }
}

Function Scan-Ports {
    Param (
        [string]$ESXHost
    )

    [System.Collections.ArrayList]$open_ports = New-Object System.Collections.ArrayList
    for ($port = 1; $port -lt 65535; $port++) {
        if (Check-Port $ESXHost $port) {
            $open_ports.Add($port) | Out-Null
        }
    }
    $open_ports
}

Function Display-Unsecure-Ports {
    Param (
        [System.Collections.ArrayList]$open_ports
    )

    $unsecure_open_ports = $open_ports | Where-Object { $_ -in $unsecure_ports }
    if ($unsecure_open_ports) {
        Write-Output "The following unsecure ports should be closed:"
        $unsecure_open_ports | ForEach-Object { Write-Output $_ }
    } else {
        Write-Output "No unsecure ports found."
    }
}

$open_ports = Scan-Ports $ESXHost
Display-Unsecure-Ports $open_ports

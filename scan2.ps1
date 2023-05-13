Function Check-Port($host, $port) {
    $socket = New-Object System.Net.Sockets.TcpClient
    try {
        $socket.Connect($host, $port)
        $socket.Connected
    }
    catch {
        $false
    }
    finally {
        $socket.Close()
    }
}

Function Scan-Ports($host) {
    $openPorts = @()
    for ($port = 1; $port -le 65535; $port++) {
        if (Check-Port $host $port) {
            $openPorts += $port
        }
    }
    $openPorts
}

Function Display-Unsecure-Ports($openPorts) {
    $unsecurePorts = @(21, 22, 23, 25, 53, 80, 110, 123, 137, 138, 139, 143, 161, 389, 443, 445, 587, 636, 993, 995, 1723, 3306, 3389)
    $unsecureOpenPorts = $openPorts | Where-Object {$unsecurePorts -contains $_}
    if ($unsecureOpenPorts) {
        Write-Output "The following unsecure ports should be closed:"
        $unsecureOpenPorts | ForEach-Object {Write-Output $_}
    }
    else {
        Write-Output "No unsecure ports found."
    }
}

$host = "127.0.0.1"
$openPorts = Scan-Ports $host
Display-Unsecure-Ports $openPorts

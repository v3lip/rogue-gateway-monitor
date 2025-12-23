
# Rogue Gateway / ARP Spoof Detection (PowerShell)

A lightweight PowerShell script that monitors your **default gateway’s MAC address** and alerts if it changes — useful for detecting **rogue gateways**, **ARP spoofing**, or unexpected network failovers.

Designed to be:

-   Simple
-   Robust (no null crashes)
-   Easy to run on any Windows machine
    

----------

## What It Does

-   Automatically detects the default IPv4 gateway
-   Records the gateway’s **baseline MAC address**
-   Periodically checks the ARP cache for changes
-   Alerts immediately if the MAC address changes
-   Continuously refreshes the console output (no scrolling spam)
    

----------

## Requirements

-   Windows
-   PowerShell 5.1 or PowerShell 7+
-   No external modules required
-   No admin rights required (unless ARP is restricted by policy)
    

----------

## Usage

1.  Clone or download the script:
    
    ```
    git clone https://github.com/v3lip/rogue-gateway-monitor.git 
    cd rogue-gateway-monitor
    ```
    
2.  Run the script:
    
    `.\rogue-gateway.ps1` 
    
3.  Stop monitoring:
    
    `Ctrl  +  C` 
    

----------

## Example Output

```
Monitoring  default  gateway: 192.168.1.1  
Press  Ctrl+C  to  stop  

Baseline  gateway  MAC: 44:d9:e7:9b:cb:ad  
[Attempt: 25]  OK (Current MAC: 44:d9:e7:9b:cb:ad)
```

If the gateway MAC changes:

```
!!! GATEWAY MAC CHANGED !!!  
Old (baseline): 44:d9:e7:9b:cb:ad 
New (current) : aa:bb:cc:dd:ee:ff 
Time: 2025-01-22  14:37:11
```

----------

## Notes

-   Legitimate MAC changes can occur in environments using:
    
    -   CARP / VRRP / HSRP
    -   Gateway failover
    -   Some Wi-Fi or proxy-ARP setups
        
-   This script is intended as a **detection aid**, not a replacement for network security controls.
    

----------

## License

MIT License — use, modify, and distribute freely.

| Perangkat | Interface | Mode | IP Address | Netmask | Gateway | Fungsi |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Router1** | `eth0` | DHCP | Otomatis dari NAT | Sesuai NAT | Otomatis | WAN (Internet) |
| | `eth1` | Static | `192.222.1.1` | `255.255.255.0` | None | Gateway LAN 1 |
| | `eth2` | Static | `192.222.2.1` | `255.255.255.0` | None | Gateway LAN 2 |
| | `eth3` | Static | `192.222.3.1` | `255.255.255.0` | None | Gateway LAN 2 |
| **Alice** | `eth0` | Static | `192.222.1.2` |`255.255.255.0` | `192.222.1.1` | Host di Subnet 1 |
| **Mika** | `eth0` | Static | `192.222.1.3`|  `255.255.255.0` | `192.222.1.1` | Host di Subnet 1 |
| **Chisa** | `eth0` | Static | `192.222.2.2` | `255.255.255.0` | `192.222.2.1` | Host di Subnet 2 |
| **Knights** | `eth0` | Static | ` 192.222.3.2` | ` 255.255.255.0` | `192.222.3.1` | Host di Subnet 3 |  
| **Eiri** | `eth0` | Static | ` 192.222.3.3` | ` 255.255.255.0` | `192.222.3.1` | Host di Subnet 3 |  
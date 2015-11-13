# salt-csf

A utility to allow you to manage common functions of CSF Firewall.

## Currently Supported
 * Individual minion configuration
 * Enabling/Disabling CSF + Testing Mode
 * Syslog Restrictions
 * WebUI Restrictions
 * Enabling/Disabling autoupdate
 * Basic Firewall Settings including
   * conntrack 
   * faststart
   * dropping of invalid packets
   * filtering on single interface
   * skipping filtering on interfaces
   * ICMP enable/disable + rate-limiting
   * Ipv4/Ipv6 SPI
   * Allowed in/out TCP/UDP ports (csf.conf) for Ipv4 and Ipv6
   * enabling/disabling IPv6
   * IPv6 Strict Mode
   * Basic custom rules (csf.allow/csf.deny/csf.ignore)
 * Advanced Firewall Settings (Iptables Rules in csfpre)

### Coming Soon
 * Flood Protection
 * Custom csfpre/csfpost entries
 * Blocklists
 * Full LFD support (allowing entries in csf.deny by LFD)

## Supported OSes
 * Ubuntu >= 12.04
 * Debian oldstable/stable/unstable
 * Centos 6/7

Note that Centos 6 requires EPEL to be installed.
No idea about RHEL support as I'm not rich.
Fedora might be supported, though I haven't bothered to test due to it's fast releases.

## Possible Settings
See the [Wiki](https://github.com/ALinuxNinja/salt-csf/wiki/CSF-Pillar-Functions) for how the pillar is set. For missing functions, see defaults.yaml

## Donations
I do a lot of work to keep things working and to implement new features. If you find this useful, please consider a donation via the Bitcoin address below.

Bitcoin: 14b7yU4qYmhrYTX1MCVQ9kLYQKCNX3x7qL

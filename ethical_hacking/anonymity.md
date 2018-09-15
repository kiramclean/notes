# Anonymity Online

## Tor
- anonymizes your connection to the internet by passing your requests through a series of virtual tunnels, so they cannot be traced back to you

## Proxychains

- different types of proxies:
  - HTTP, SOCKS4, and SOCKS5
  - SOCKS5 can anonymize any type of traffic (not just HTTP)
  - SOCKS4 is similar to SOCKS5, but does not support ipv6 or QDP protocols

- `dynamic_chain` is the most stable, skips proxies that are down (strict chain requires all be up and are hit in the specified order, otherwise the connection fails)

- `random_chain` will use a new random proxy for every packet (or as often as specified)

- need to also proxy DNS to prevent DNS leaks

> ### DNS leak
- someone gets the IP address of the DNS server you are using (when they can't get your IP address directly)
- because DNS servers resolve domains to IP addresses, this can be used to get your IP address, then your location

- proxies default to tor only, add socks5 as well at least

- duckduckgo does not store your IP address

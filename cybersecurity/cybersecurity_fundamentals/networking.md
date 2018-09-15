# Networking

- TCP is used when accuracy and integrity, so has lots of overhead (waits for an ackowledgement, resends bytes not acknolwedged)
- UDP has no overhead and is quicker, so more efficient, but you might lose some data (perceived as a degradation of sound or image quality)

## Switches

- connect devices on the same network together
- when a switch receives an ethernet frame:
  - switch checks the destination MAC address on the incoming ethernet frame
  - if the switch knows where that device is, it sends out the frame to the right interface (the one connected to the device it knows about)
  - else it sends the frame out from all interfaces except the one on which the frame originated
- switches do not change any part of the frame (unlike routers)

## Routers

- if a router doesn't know about the destination network and does not have a default route, it will drop the packet

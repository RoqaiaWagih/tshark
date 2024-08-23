# `tshark` Command Guide

`tshark` is a powerful command-line tool for network traffic capture and analysis. It is a part of the Wireshark suite and is ideal for scripting and automation tasks in network diagnostics.

## Table of Contents
- [Basic Usage](#basic-usage)
- [Specifying an Interface](#specifying-an-interface)
- [Writing Output to a File](#writing-output-to-a-file)
- [Reading from a File](#reading-from-a-file)
- [Applying Filters](#applying-filters)
  - [Capture Filter](#capture-filter)
  - [Display Filter](#display-filter)
- [Displaying Specific Fields](#displaying-specific-fields)
- [Counting Packets](#counting-packets)
- [Limiting the Number of Packets](#limiting-the-number-of-packets)
- [Displaying Packet Statistics](#displaying-packet-statistics)
- [Advanced Usage Examples](#advanced-usage-examples)
  - [Analyzing DNS Traffic](#analyzing-dns-traffic)
  - [Monitoring HTTP Traffic](#monitoring-http-traffic)
  - [Extracting HTTP Objects](#extracting-http-objects)
- [Additional Commands](#additional-commands)
  - [Following TCP Streams](#following-tcp-streams)
  - [Analyzing RTP Streams](#analyzing-rtp-streams)
  - [Exporting VoIP Calls](#exporting-voip-calls)
  - [Analyzing SSL/TLS Handshakes](#analyzing-ssltls-handshakes)
  - [Generating Statistics](#generating-statistics)
- [Conclusion](#conclusion)

## Basic Usage
```bash
tshark
```
This command starts capturing packets on the default network interface.

## Specifying an Interface
```bash
tshark -i eth0
```
Capture packets on a specific interface, such as `eth0`.

## Writing Output to a File
```bash
tshark -i eth0 -w capture.pcap
```
Save the captured packets to a file named `capture.pcap` for later analysis.

## Reading from a File
```bash
tshark -r capture.pcap
```
Read and display packets from a saved capture file.

## Applying Filters
### Capture Filter
```bash
tshark -i eth0 -f "tcp port 80"
```
Capture only traffic on TCP port 80.

### Display Filter
```bash
tshark -r capture.pcap -Y "http"
```
Display only HTTP traffic from a capture file.

## Displaying Specific Fields
```bash
tshark -r capture.pcap -T fields -e ip.src -e ip.dst -e frame.len
```
Extract specific fields such as source IP, destination IP, and frame length.

## Counting Packets
```bash
tshark -r capture.pcap -q -z io,phs
```
Provide a summary with packet counts per protocol.

## Limiting the Number of Packets
```bash
tshark -i eth0 -c 10
```
Capture only 10 packets.

## Displaying Packet Statistics
```bash
tshark -z conv,tcp
```
Show TCP conversation statistics.

## Advanced Usage Examples
### Analyzing DNS Traffic
```bash
tshark -i eth0 -Y "dns" -T fields -e dns.qry.name -e dns.a
```
Display DNS query names and corresponding IP addresses.

### Monitoring HTTP Traffic
```bash
tshark -i eth0 -Y "http" -T fields -e http.host -e http.request.uri
```
Monitor HTTP traffic, showing hostnames and requested URIs.

### Extracting HTTP Objects
```bash
tshark -r capture.pcap --export-objects http,/path/to/directory
```
Extract HTTP objects (like files) from a capture file to a specified directory.

## Additional Commands
### Following TCP Streams
```bash
tshark -r capture.pcap -z follow,tcp,ascii,1
```
Follow a TCP stream and display it in ASCII format.

### Analyzing RTP Streams
```bash
tshark -q -z rtp,streams -r capture.pcap
```
Analyze RTP streams in a capture file.

### Exporting VoIP Calls
```bash
tshark -r capture.pcap -q -z voip,rtp,streams
```
Extract VoIP calls from a capture file.

### Analyzing SSL/TLS Handshakes
```bash
tshark -Y "ssl.handshake" -T fields -e ssl.handshake.type
```
Display SSL/TLS handshake types.

### Generating Statistics
```bash
tshark -r capture.pcap -z io,stat,1,"COUNT(frame) frame","SUM(frame.len) bytes"
```
Generate statistics on frame count and byte count per second.

## Conclusion
`tshark` is a versatile tool for network traffic analysis in Linux. Its wide range of options and filters make it suitable for both simple packet captures and complex traffic analysis tasks. Whether you're monitoring live traffic or analyzing saved captures, `tshark` provides a robust set of features to meet your needs.

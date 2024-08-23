#!/usr/bin/bash

# Print a welcome message
echo "Welcome to the TShark Command Script"

# Check if the user provided an argument (e.g., interface name)
if [ -z "$1" ]; then
  echo "Usage: $0 <network-interface>"
  echo "Example: $0 eth0"
  exit 1
fi

# Store the interface name from the argument
INTERFACE=$1

# Define a directory to save capture files
CAPTURE_DIR="./captures"
mkdir -p $CAPTURE_DIR

# Basic Usage: Start capturing packets on the specified interface
echo "Starting basic capture on interface $INTERFACE..."
tshark -i $INTERFACE -c 10 -w $CAPTURE_DIR/basic_capture.pcap
echo "Capture saved to $CAPTURE_DIR/basic_capture.pcap"

# Reading from the saved capture file
echo "Reading from the saved capture file..."
tshark -r $CAPTURE_DIR/basic_capture.pcap

# Filtering traffic: Capture only HTTP traffic on the specified interface
echo "Capturing only HTTP traffic on $INTERFACE..."
tshark -i $INTERFACE -f "tcp port 80" -c 10 -w $CAPTURE_DIR/http_capture.pcap
echo "HTTP traffic capture saved to $CAPTURE_DIR/http_capture.pcap"

# Displaying specific fields from the capture file
echo "Displaying source and destination IPs from the HTTP capture..."
tshark -r $CAPTURE_DIR/http_capture.pcap -T fields -e ip.src -e ip.dst

# Counting packets in the capture file
echo "Counting packets per protocol in the HTTP capture..."
tshark -r $CAPTURE_DIR/http_capture.pcap -q -z io,phs

# Analyzing DNS traffic
echo "Analyzing DNS traffic on $INTERFACE..."
tshark -i $INTERFACE -Y "dns" -c 10 -T fields -e dns.qry.name -e dns.a -w $CAPTURE_DIR/dns_capture.pcap
echo "DNS traffic analysis saved to $CAPTURE_DIR/dns_capture.pcap"

# Monitoring HTTP traffic with specific fields
echo "Monitoring HTTP traffic on $INTERFACE..."
tshark -i $INTERFACE -Y "http" -c 10 -T fields -e http.host -e http.request.uri -w $CAPTURE_DIR/monitored_http_capture.pcap
echo "Monitored HTTP traffic saved to $CAPTURE_DIR/monitored_http_capture.pcap"

# Extracting HTTP objects from the capture file
echo "Extracting HTTP objects from the capture file..."
tshark -r $CAPTURE_DIR/monitored_http_capture.pcap --export-objects http,$CAPTURE_DIR/http_objects
echo "HTTP objects extracted to $CAPTURE_DIR/http_objects"

# Following a TCP stream in a capture file
echo "Following TCP streams in the capture file..."
tshark -r $CAPTURE_DIR/basic_capture.pcap -z follow,tcp,ascii,1

# Analyzing RTP streams
echo "Analyzing RTP streams..."
tshark -q -z rtp,streams -r $CAPTURE_DIR/basic_capture.pcap

# Exporting VoIP calls
echo "Exporting VoIP calls..."
tshark -r $CAPTURE_DIR/basic_capture.pcap -q -z voip,rtp,streams

# Analyzing SSL/TLS handshakes
echo "Analyzing SSL/TLS handshakes..."
tshark -Y "ssl.handshake" -T fields -e ssl.handshake.type -r $CAPTURE_DIR/basic_capture.pcap

# Generating statistics from a capture file
echo "Generating statistics..."
tshark -r $CAPTURE_DIR/basic_capture.pcap -z io,stat,1,"COUNT(frame) frame","SUM(frame.len) bytes"

# Script complete
echo "TShark Command Script completed successfully!"

#!/usr/bin/env python2
"""
Turn pcap into csv file.

Problem:  A client is downloading a large file from a server and we want to
          figure out if the throughput of the download degrades over time.

Solution: We analyze the pcap file of the download and extract the ACK segments
          that the client sends to the server.  From the ACK segments we can
          infer how much data was transferred in a given time interval
          (CUM_TIME_THRESHOLD).  We can then plot the number of downloaded
          bytes per time interval and do a simple qualitative inspection.
"""

import sys
import time

import scapy.all as scapy

sent_bytes = 0
streams = {}
timestamp = None
total_time = 0

def ignore_packet(packet):

    # Make sure that we only inspect the given client and server IP
    # addresses.
    if not packet.haslayer(scapy.IP):
        return True

    # Make sure that we only inspect the given client and server TCP ports.
    if not packet.haslayer(scapy.TCP):
        return True
    if not (packet[scapy.TCP].dport == 443):
        return True

    # Make sure that we're only inspecting ACK segments.
    if not (packet[scapy.TCP].flags.A):
        return True

    #ignore packets after we stopped counting bytes
    if (packet.time - timestamp) > total_time:
        return True

    return False


def process_packet(packet):

    global prev_ack
    global sent_bytes
    global timestamp

    if not timestamp:
        timestamp = packet.time

    if ignore_packet(packet):
        return

    # Remember timestamp and ACK number of the very first segment.
    if packet[scapy.TCP].sport not in streams:
        streams[packet[scapy.TCP].sport] = packet[scapy.TCP].ack
        return

    prev_ack = streams[packet[scapy.TCP].sport]
    ack = packet[scapy.TCP].ack
    sent_bytes += len(packet[scapy.TCP].payload)
    prev_ack = ack

    if packet[scapy.TCP].flags.F:
        del streams[packet[scapy.TCP].sport]
        return

    return


if __name__ == "__main__":

    for i in range(1,11):
    	for j in range(0,10):
        	test_id = i
                pcap_file = ("%(dr)d/dump%(fn)d.pcap" % {"dr": j, "fn": i} )

                sys.stderr.write("Processing dir %(dr)d and file %(fn)d\n" % {"dr":j,"fn":i})

                # Find maximum timestamp
                start_time = None
                end_time = None
                with open("%(dr)d/metrics-%(fn)d.csv" % {"dr":j, "fn":i}) as f:
                    for line in f:
                        time = line.split(",")[0]
                        if time == "time":
                            continue
                        if start_time is None:
                            start_time = time
                        else:
                            end_time = time
                total_time = int(end_time) - int(start_time)

        	# Figure out the Socks port from the log file
                scapy.sniff(offline=pcap_file, prn=process_packet, store=0)
                print(sent_bytes)

                sent_bytes = 0
                streams = {}
                timestamp = None

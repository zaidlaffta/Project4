/**
 * ANDES Lab - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   2023/10/29
 *
 */

#ifndef TRANSPORTPACKET_H
#define TRANSPORTPACKET_H


#include "protocol.h"
#include "channels.h"

#define INITIAL_RTT 50;

enum{
    SERV_WINDOW_SIZE = 5,
	TCP_PACKET_HEADER_LENGTH = 8,
	TCP_PACKET_MAX_PAYLOAD_SIZE = 28 - TCP_PACKET_HEADER_LENGTH //<---------------- should the tcp be the same size as packet?
};

enum flags{
    DATA_FLAG = 0,
    ACK_FLAG = 1,
    SYN_FLAG = 2,
    SYN_ACK_FLAG = 3,
    FIN_FLAG = 4,
    FIN_ACK_FLAG = 5,
    CONN_ACK_FLAG = 6
};

typedef nx_struct transportPack{
    // sourcePort, destinationPort, sequence, acknowledgement, flags, advertised window, data
    nx_uint8_t srcPort;
    nx_uint8_t destPort;
    nx_uint8_t seq;
    nx_uint8_t sentACK;
    nx_uint8_t lastReceivedACK;
    nx_uint8_t flags;
    nx_uint8_t window;
    nx_uint8_t payload[TCP_PACKET_MAX_PAYLOAD_SIZE];
}transportPack;

#endif

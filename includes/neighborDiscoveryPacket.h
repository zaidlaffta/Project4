/**
 * CSE 160 - University of California, Merced
 *
 * @author Ritesh Patro
 * @date   09/25/2023
 *
 */

#ifndef NEIGHORDISCOVERYPACKET_H
#define NEIGHBORDISCOVERYPACKET_H


#include "protocol.h"
#include "channels.h"

enum{
	PACKET_HEADER_LENGTH = 1, //changed from 8
	PACKET_MAX_PAYLOAD_SIZE = 20 - PACKET_HEADER_LENGTH, //changed from 28
	MAX_TTL = 15
};

typedef nx_struct neighDiscPack{
	nx_uint8_t reqOrReply;		//0 = Request, 1 = Reply
	nx_uint8_t data[0];
}neighDiscPack;

/*
 * logPack
 * 	Sends Neighbor Discovery packet information to the general channel.
 * @param:
 * 		pack *input = pack to be printed.
 */
void logPack(pack *input){
	dbg(NEIGHBOR_CHANNEL, "ReqOrReply: %hhu\n",
	input->reqOrReply);
}

#endif

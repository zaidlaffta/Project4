/**
 * ANDES Lab - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   2023/10/22
 *
 */

#ifndef ROUTEPACKET_H
#define ROUTEPACKET_H


#include "protocol.h"
#include "channels.h"

enum{
	RTE_PACKET_HEADER_LENGTH = 8,
	RTE_PACKET_MAX_PAYLOAD_SIZE = 28 - PACKET_HEADER_LENGTH
};


typedef nx_struct routePack{
    nx_uint16_t neighbor;
    nx_uint16_t cost;
    nx_uint16_t currentNode;
	nx_uint16_t data[0];
}routePack;

/*
 * logPack
 * 	Sends packet information to the general channel.
 * @param:
 * 		pack *input = pack to be printed.
 */
// void logPack(routePack *input){
// 	dbg(GENERAL_CHANNEL, "Src: %hhu Dest: %hhu Seq: %hhu TTL: %hhu Protocol: %hhu Neighbor: %hhu Cost: %hhu currentNode: %hhu Payload: %s\n",
// 	input->src, input->dest, input->seq, input->TTL, input->protocol, input->payload);
// }

#endif

/**
 * CSE 160 - University of California, Merced
 *
 * @author Ritesh Patro
 * @date   09/25/2023
 *
 */

#ifndef NEIGHORDISCOVERYSTATS_H
#define NEIGHBORDISCOVERYSTATS_H


# include "protocol.h"
#include "channels.h"
#include "packet.h"

struct neighborDiscoveryStats{
	uint16_t packetsReceived;
	uint16_t packetsSent;
	uint16_t lastSeqNum;

	bool isActive(uint16_t recentPacketSeq) {
		if(recentPacketSeq - lastSeqNum > 5) { //if more than 5 packets lost in a row, neighbor is too unreliable
			return false;
		}

		float linkQuality = float(packetsReceived) / packetsSent;

		if(linkQuality < 0.5) {
			return false;
		}
		
		return true;
	}
}neighborDiscoveryStats;


#endif
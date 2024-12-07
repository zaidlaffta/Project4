/**
 * CSE 160 - University of California, Merced
 *
 * @author Ritesh Patro
 * @date   09/08/2023
 *
 */

#include "../../includes/packet.h"
#include "../../includes/protocol.h"

module NeighborDiscoveryP {
    provides interface NeighborDiscovery;

    uses interface Random;

    uses interface Hashmap<uint16_t> as packetsReceived;
    uses interface Hashmap<uint16_t> as packetsSent;
    uses interface Hashmap<uint16_t> as lastSeqNum;
    uses interface Hashmap<float> as linkQuality;

    uses interface Timer<TMilli> as sendTimer;

    uses interface SimpleSend as Sender;

    uses interface Flooding as Flooder;
}

implementation {
    uint8_t* pkt;
    uint16_t ourSeq = 0;
    const int timeToPost = 150000; //timeToPost = seconds of delay between neighbor packets sent
    uint16_t sendNode;
    uint16_t receivedPackSeq;

    void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);
    bool isActive(pack *msg);

    task void sendNeighborPackTask() {
        pack sendPackage;
        uint8_t payload[0];

        if(sendNode == AM_BROADCAST_ADDR) { //check sendNode: if AM_BROADCAST_ADDR, means to send a req pack
            dbg(NEIGHBOR_CHANNEL, "Neighbor Discovery Request Sent\n");
            makePack(&sendPackage, TOS_NODE_ID, sendNode, 0, 11, ourSeq, payload, PACKET_MAX_PAYLOAD_SIZE); //create packet
        }

        else { //check sendNode: if not AM_BROADCAST_ADDR, means to send reply pack
            makePack(&sendPackage, TOS_NODE_ID, sendNode, 0, 12, receivedPackSeq, payload, PACKET_MAX_PAYLOAD_SIZE); //create packet

            dbg(NEIGHBOR_CHANNEL, "Neighbor Discovery Reply Sent to Node [%d]\n", sendPackage.dest);
        }

        call Sender.send(sendPackage, sendPackage.dest); //use SimpleSend to send packet
    }

    command error_t NeighborDiscovery.postSendTask(){ //should be called from Node.nc right after initialization of network topo
        if(call sendTimer.isRunning() == FALSE){
            //make a neighbor discovery packet
            ourSeq = ourSeq + 1;
            sendNode = AM_BROADCAST_ADDR;
            post sendNeighborPackTask();

            call sendTimer.startOneShot(timeToPost);
            return SUCCESS;
        }

        else return FAIL;
    }

    // Once the timer fires, we post the sendNeighborPackTask().
   event void sendTimer.fired(){
        call NeighborDiscovery.postSendTask(); //makes sure to start timer again to send another neighbor disc packet after delay
   }

    command error_t NeighborDiscovery.receivedNeighborPack(message_t* myMsg, void* payload) {
        uint16_t cost = 1;
        pack* msg=(pack*) payload;
        
        if(msg->protocol == 11) { //if sent Request Neighbor Discovery packet(maybe should be triple equals in if statement??)
            dbg(NEIGHBOR_CHANNEL, "Packet is Neighbor Discovery Request Packet from Node %d\n", msg->src);
            sendNode = msg->src;
            post sendNeighborPackTask(); //sending reply back to node
        }
        
        else { //else means sent Reply Neighbor Discovery packet
            dbg(NEIGHBOR_CHANNEL, "Packet is Neighbor Discovery Reply Packet from Node %d\n", msg->src);
            
            signal NeighborDiscovery.passNeighbor(msg->src, cost, payload);
            //call Flooder.passNeighbor(msg->src, cost, payload); //------------------------------------------------------------------------------------------------------------

            if( !( call packetsReceived.contains(msg->src) ) ) { //if neighbor not recognized, add it to table
                call packetsReceived.insert(msg->src, 1);
                call packetsSent.insert(msg->src, 1);
                call lastSeqNum.insert(msg->src, msg->seq);
                call linkQuality.insert(msg->src, (float)(call packetsReceived.get(msg->src)) / (call packetsSent.get(msg->src)));
            }
            
            else { //if neighbor recognized, update statistics
                //increment statistic for num packets received from that neighbor
                call packetsReceived.insert(msg->src, call packetsReceived.get(msg->src) + 1);

                if( isActive(msg) == 0 ) {
                    call packetsReceived.remove(msg->src); //if neighbor node is unreliable, remove from table
                    call packetsSent.remove(msg->src);
                    call lastSeqNum.remove(msg->src);
                }
            }
        
        }

        return SUCCESS;
    }

    bool isActive(pack *msg) { //return value of 1 == true, 0 == false
        float alpha = 0.8;
        float tempLinkQuality = call linkQuality.get(msg->src);
        uint16_t tempPacketsReceived = call packetsReceived.get(msg->src);
        uint16_t tempPacketsSent = call packetsSent.get(msg->src);

		if(msg->seq - (call lastSeqNum.get(msg->src)) > 5) { //if more than 5 packets lost in a row, neighbor is too unreliable
			return 0;
		}

        //exponentially weighted moving average
		tempLinkQuality = (alpha)*((float)(tempPacketsReceived) / (tempPacketsSent)) + (1.0-alpha)*(tempLinkQuality);

		if(tempLinkQuality < 0.5 && tempPacketsSent > 10) {
			return 0;
		}
		
        call lastSeqNum.insert(msg->src, msg->seq); //if neighbor is active, update last sequence number
		return 1;
	}

    void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
      Package->src = src;
      Package->dest = dest;
      Package->TTL = TTL;
      Package->seq = seq;
      Package->protocol = protocol;
      memcpy(Package->payload, payload, length);
   }
}
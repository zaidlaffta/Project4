/**
 * ANDES Lab - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   2023/09/08
 *
 */

#include "../../includes/protocol.h"
#include "../../includes/packet.h"
#include "../../includes/channels.h"
#include "../../includes/routePacket.h"

module FloodingP{
   provides interface Flooding;

   uses interface NeighborDiscovery;
   uses interface Routing as Router;

   uses interface SimpleSend as FloodSend;
   uses interface Hashmap<uint32_t> as SeqHash;
}

implementation{
   uint16_t ourSeq = 1;
   pack sendPackage;

   // Prototypes
   void makeFloodPack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);

   command error_t Flooding.floodHandle(uint16_t destination, uint8_t TTL, uint16_t seqIN, uint8_t *payload) {
      dbg(FLOODING_CHANNEL, "In floodHandle \n");

      call SeqHash.insert(TOS_NODE_ID, seqIN);

      makeFloodPack(&sendPackage, TOS_NODE_ID, destination, TTL-1, PROTOCOL_FLOODING, seqIN, payload, PACKET_MAX_PAYLOAD_SIZE);
      call FloodSend.send(sendPackage, AM_BROADCAST_ADDR);
      return SUCCESS;

   }

   event void NeighborDiscovery.passNeighbor(uint16_t neighborID, uint16_t cost, uint8_t *payload){
      uint8_t buff_len = PACKET_MAX_PAYLOAD_SIZE;
      uint8_t buff[buff_len];
      uint16_t newTTL = 50;
      
      //strcpy((char*) payload,"TEMP");
      buff[0] = neighborID;
      buff[1] = cost;
      buff[2] = TOS_NODE_ID;
      
      call Router.addToTempTable(neighborID, neighborID, cost); // from payload we recieve and we need to dissect for future
      call SeqHash.insert(TOS_NODE_ID, ourSeq);

      makeFloodPack(&sendPackage, TOS_NODE_ID, 99, newTTL, PROTOCOL_LINKSTATE, ourSeq, (uint8_t *) buff, PACKET_MAX_PAYLOAD_SIZE);

      ourSeq = ourSeq + 1;
      call FloodSend.send(sendPackage, AM_BROADCAST_ADDR);
   }

   command error_t Flooding.floodRecieve(message_t* msg, void* payload) {
      pack* myMsg = (pack*) payload;

      if (myMsg->protocol == 6){
         //dbg(FLOODING_CHANNEL, "contents(*payload) = [%s]\n", myMsg->payload);
         // if (TOS_NODE_ID == 4){ //testing
         //    dbg(FLOODING_CHANNEL, "-----------\n");
         //    dbg(FLOODING_CHANNEL, "h->seq = [%d]\n", myMsg->seq);
         //    dbg(FLOODING_CHANNEL, "h->src = [%d]\n", myMsg->src);
         //    dbg(FLOODING_CHANNEL, "h->ourSeq = [%d]\n", ourSeq);
         //    dbg(FLOODING_CHANNEL, "h->neighbor = [%d]\n", (myMsg->payload)[0]);
         //    dbg(FLOODING_CHANNEL, "h->cost = [%d]\n", (myMsg->payload)[1]);
         //    dbg(FLOODING_CHANNEL, "h->currentNode = [%d]\n", (myMsg->payload)[2]);
         // }
         call Router.addToTempTable((myMsg->payload)[2], (myMsg->payload)[0], (myMsg->payload)[1]); // from payload we recieve and we need to dissect for future

         if (myMsg->dest == TOS_NODE_ID){
            dbg(FLOODING_CHANNEL, "Final Destination reached\n");
            return SUCCESS;
         }
         else if (myMsg->TTL > 0) {
            if (call SeqHash.contains(myMsg->src)) {
               if  (call SeqHash.get(myMsg->src) < myMsg->seq) {
                  call SeqHash.remove(myMsg->src);
                  call SeqHash.insert(myMsg->src, myMsg->seq);

                  // call Routing.printRouteTable(); //added for demo
                  // dbg(ROUTING_CHANNEL, "I got the packet from [%d]", myMsg->src); // added for demo

                  makeFloodPack(&sendPackage, myMsg->src, myMsg->dest, myMsg->TTL-1, PROTOCOL_LINKSTATE, myMsg->seq, myMsg->payload, PACKET_MAX_PAYLOAD_SIZE);
                  call FloodSend.send(sendPackage, AM_BROADCAST_ADDR);
               }
            }
            else {
               call SeqHash.insert(myMsg->src, myMsg->seq);

               makeFloodPack(&sendPackage, myMsg->src, myMsg->dest, myMsg->TTL-1, PROTOCOL_LINKSTATE, myMsg->seq, myMsg->payload, PACKET_MAX_PAYLOAD_SIZE);
               call FloodSend.send(sendPackage, AM_BROADCAST_ADDR);
            }
            return SUCCESS;
         }



      }
      else {
         if (myMsg->dest == TOS_NODE_ID){
            dbg(FLOODING_CHANNEL, "Final Destination reached\n");
            return SUCCESS;
         }
         else if (myMsg->TTL > 0) {
            if (call SeqHash.contains(myMsg->src)) {
               if  (call SeqHash.get(myMsg->src) < myMsg->seq) {
                  call SeqHash.remove(myMsg->src);
                  call SeqHash.insert(myMsg->src, myMsg->seq);

                  makeFloodPack(&sendPackage, myMsg->src, myMsg->dest, myMsg->TTL-1, PROTOCOL_FLOODING, myMsg->seq, myMsg->payload, PACKET_MAX_PAYLOAD_SIZE);
                  call FloodSend.send(sendPackage, AM_BROADCAST_ADDR);
               }
            }
            else {
               call SeqHash.insert(myMsg->src, myMsg->seq);

               makeFloodPack(&sendPackage, myMsg->src, myMsg->dest, myMsg->TTL-1, PROTOCOL_FLOODING, myMsg->seq, myMsg->payload, PACKET_MAX_PAYLOAD_SIZE);
               call FloodSend.send(sendPackage, AM_BROADCAST_ADDR);
            }
            return SUCCESS;
         }
      }

      return FAIL;
   }

   void makeFloodPack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
      Package->src = src;
      Package->dest = dest;
      Package->TTL = TTL;
      Package->seq = seq;
      Package->protocol = protocol;
      memcpy(Package->payload, payload, length);
   }
}
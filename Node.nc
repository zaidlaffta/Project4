/*
 * ANDES Lab - University of California, Merced
 * This class provides the basic functions of a network node.
 *
 * @author UCM ANDES Lab
 * @date   2013/09/03
 *
 */
#include <Timer.h>
#include "includes/command.h"
#include "includes/packet.h"
#include "includes/routePacket.h"
#include "includes/CommandMsg.h"
#include "includes/sendInfo.h"
#include "includes/channels.h"

module Node{
   uses interface Boot;

   uses interface SplitControl as AMControl;
   uses interface Receive;

   uses interface SimpleSend as Sender;

   uses interface CommandHandler;

   // added for project 1
   
   uses interface Flooding;

   uses interface NeighborDiscovery;

   // added for project 2

   uses interface Timer<TMilli> as LinkStateTimer;

   uses interface Routing;

   // added for project 3

   uses interface Transport;

   // added for project 4

   uses interface ChatClient;
}

implementation{
   pack sendPackage;

   // Prototypes
   void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);

   event void Boot.booted(){
      uint32_t startTime, wait;
      call AMControl.start();
      dbg(GENERAL_CHANNEL, "Booted\n");

      startTime = 5000;
      wait = 200000;
      call LinkStateTimer.startPeriodicAt(startTime, wait);
      //dbg(ROUTING_CHANNEL, "periodicTimer set at %d firing every %d\n", startTime, wait);

      // below should be removed after neighbordiscovery and dijkstra implemented
      //call Routing.createStaticRoutingTable();
      //call Routing.createPermRouteTable(); //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   }

   event void AMControl.startDone(error_t err){
      if(err == SUCCESS){
         dbg(GENERAL_CHANNEL, "Radio On\n");
         dbg(NEIGHBOR_CHANNEL, "Neighbor Discovery Inititiated\n"); //added to fire timer to send NeighDisc
         call Routing.addToTempTable(TOS_NODE_ID,TOS_NODE_ID,0); // added to add yourself w/ cost 0 in routing table
         call NeighborDiscovery.postSendTask();
      }else{
         //Retry until successful
         call AMControl.start();
      }
   }

   event void AMControl.stopDone(error_t err){}

   event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
      //dbg(GENERAL_CHANNEL, "Packet Received\n");
      if(len==sizeof(pack)){
         pack* myMsg=(pack*) payload;
         routePack *h=(routePack*) payload;
         //dbg(GENERAL_CHANNEL, "Package Payload: %s\n", myMsg->payload);
         //dbg(GENERAL_CHANNEL, "TTL[%d] | Protocol[%d]\n", myMsg->TTL, myMsg->protocol);

         if ((myMsg -> TTL == 0) && (myMsg->protocol  != 11) && (myMsg->protocol  != 12)) {
            //dbg(GENERAL_CHANNEL, 'drop\n');
         } // dropping package
         else if ((myMsg->protocol == 7) || (myMsg->protocol == 6)){
            //dbg(FLOODING_CHANNEL, "src[%d]\n", myMsg->src);
            // dbg(FLOODING_CHANNEL, "node.passNeighbor -> neighbor [%d]\n", h->neighbor);
            // dbg(FLOODING_CHANNEL, "node.passNeighbor -> cost [%d]\n", h->cost);
            // dbg(FLOODING_CHANNEL, "node.passNeighbor -> TOS_NODE_ID [%d]\n", h->currentNode);
            call Flooding.floodRecieve(msg, payload);
         }
         else if ((myMsg->protocol  == 8) || (myMsg->protocol == 9)){
            //dbg(ROUTING_CHANNEL, "Route TTL: %d\n", myMsg->TTL);
            call Routing.routeRecieve(msg, payload);
         }
         else if(myMsg -> protocol == 11 || myMsg -> protocol == 12) { //added so that if protocol = PROTOCOL_NEIGHBORDISC, calls command in NeighborDiscoveryP
            //call NeighborDiscovery.receivedNeighborPack(myMsg);
            call NeighborDiscovery.receivedNeighborPack(msg, payload);
         }
         else {
            dbg(GENERAL_CHANNEL, "Package Payload: %s\n", myMsg->payload);
         }

         return msg;
      }
      dbg(GENERAL_CHANNEL, "Unknown Packet Type %d\n", len);
      return msg;
   }


   event void CommandHandler.ping(uint16_t destination, uint8_t *payload){
      dbg(GENERAL_CHANNEL, "PING EVENT \n");
      makePack(&sendPackage, TOS_NODE_ID, destination, 0, 0, 0, payload, PACKET_MAX_PAYLOAD_SIZE);
      call Sender.send(sendPackage, destination);
   }

   event void CommandHandler.printNeighbors(){}

   event void CommandHandler.printRouteTable(){
      dbg(ROUTING_CHANNEL, "PRINT ROUTE TABLE EVENT\n");
      call Routing.printRouteTable();
   }

   event void CommandHandler.printLinkState(){}

   event void CommandHandler.printDistanceVector(){}

   event void CommandHandler.setTestServer(uint8_t port){
      dbg(TRANSPORT_CHANNEL, "in setTestServer()\n");
      call Transport.addServer(port);
   }

   event void CommandHandler.setTestClient(uint16_t destination, uint8_t srcPort, uint destPort, uint16_t transfer){
      dbg(TRANSPORT_CHANNEL, "in setTestClient()\n");
      call Transport.addClient(destination, srcPort, destPort, transfer);
      //dbg(TRANSPORT_CHANNEL, "aftercall\n");
   }

   event void CommandHandler.setAppServer(){}

   event void CommandHandler.setAppClient(){}

   // Created for Project 1 (Flooding)
   event void CommandHandler.flood(uint16_t destination, uint8_t TTL, uint16_t seqIN, uint8_t *payload){
      dbg(FLOODING_CHANNEL, "Flood EVENT \n");
      call Flooding.floodHandle(destination, TTL, seqIN, payload);
   }

   event void CommandHandler.route(uint16_t destination, uint8_t TTL, uint16_t seqIN, uint8_t *payload){
      dbg(ROUTING_CHANNEL, "Route EVENT \n");
      call Routing.initiateRouting(destination, TTL, seqIN, payload);
      //call Routing.discoverAndFlood(destination, TTL, seqIN, payload);
   }

   event void CommandHandler.serverConnection(uint8_t clientPort, char *payload) {
      // dbg(CHAT_CHANNEL, "[NODE %d] serverConnection EVENT \n", TOS_NODE_ID);
      // dbg(CHAT_CHANNEL, "[NODE %d] clientPort [%d] | userName [%s]\n", TOS_NODE_ID, clientPort, payload);
      dbg(CHAT_CHANNEL, "[INITIATED IN NODE %d] Payload Contents: %s", TOS_NODE_ID, payload);
      call ChatClient.handleMsg(payload);
   }

   event void CommandHandler.broadcastMsg(char *payload) {
      dbg(GENERAL_CHANNEL, "[NODE %d] broadCastMsg EVENT \n", TOS_NODE_ID);
      dbg(GENERAL_CHANNEL, "[NODE %d] msg [%s]\n", TOS_NODE_ID, (char*)payload);
      //makePack(&sendPackage, TOS_NODE_ID, destination, 0, 0, 0, payload, PACKET_MAX_PAYLOAD_SIZE);
      //call Sender.send(sendPackage, destination);
   }

   event void NeighborDiscovery.passNeighbor(uint16_t neighborID, uint16_t cost, uint8_t *payload){}

   // Created for Project 2 (Routing)
   event void LinkStateTimer.fired() {
      //dbg(ROUTING_CHANNEL, "Timer fired\n");

      call Routing.createPermRouteTable();
      call Routing.decrementAge();
      //call Routing.printRouteTable();
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

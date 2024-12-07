/**
 * ANDES Lab - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   2023/10/08
 *
 */

#include "../../includes/protocol.h"
#include "../../includes/packet.h"
#include "../../includes/channels.h"

module RoutingP{
   provides interface Routing;

   uses interface SimpleSend as RouteSend;

   uses interface Transport;
   
//    uses interface Hashmap<uint32_t> as routeHashTable;
//    uses interface Hashmap<uint32_t> as routeCostTable;

//    uses interface Hashmap<uint32_t> as routeTempTable;
//    uses interface Hashmap<uint32_t> as tempCostTable;
}

implementation{
    typedef struct routingTable{ // struct works as intended
        uint32_t destNode; // the node we want to hop to
        uint32_t nextNode; // the node we need to hop to to get to destNode
        uint32_t cost;
        uint32_t age;
        uint32_t flag; // to see if the element exists
    }routingTable;

    pack sendPackage;
    uint32_t ageVal = 500;
    routingTable permRoutingTable[255];
    routingTable tempRoutingTable[255];
    uint32_t index = 0;

    // Prototypes
    void makeRoutePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t Protocol, uint16_t seq, uint8_t *payload, uint8_t length);
    //void createPermRouteTable();
    uint32_t elementCounter();

    // to be commented out once neighbordiscovery and dijkstra implemented
    command error_t Routing.createStaticRoutingTable(){
        //dbg(ROUTING_CHANNEL, "In createStaticRoutingTable for Node[%d]\n", TOS_NODE_ID);
        
        switch(TOS_NODE_ID){
        case 1:
            dbg(ROUTING_CHANNEL, "In createStaticRoutingTable for Node[%d]\n", TOS_NODE_ID);
            //dbg(ROUTING_CHANNEL, "BEG (CSRT)     routeTempTable.size [%d]\n", call routeTempTable.size());

            //dbg(ROUTING_CHANNEL, "MID (CSRT)     Table[0].destNode + Table[0].nextNode= [%d]\n", Table[0].destNode + Table[0].nextNode);
            // permRoutingTable[1].destNode = 1;
            // permRoutingTable[1].nextNode = 1;
            // permRoutingTable[2].destNode = 2;
            // permRoutingTable[2].nextNode = 2;
            // permRoutingTable[3].destNode = 3;
            // permRoutingTable[3].nextNode = 3;
            // permRoutingTable[4].destNode = 4;
            // permRoutingTable[4].nextNode = 3;
            // permRoutingTable[5].destNode = 5;
            // permRoutingTable[5].nextNode = 2;
            // permRoutingTable[6].destNode = 6;
            // permRoutingTable[6].nextNode = 3;

            //------------------------------------------------------------------ ^
            tempRoutingTable[0].destNode = 2;
            tempRoutingTable[0].nextNode = 2;
            tempRoutingTable[0].cost = 1;
            tempRoutingTable[0].flag = 1;
            tempRoutingTable[1].destNode = 3;
            tempRoutingTable[1].nextNode = 3;
            tempRoutingTable[1].cost = 1;
            tempRoutingTable[1].flag = 1;
            tempRoutingTable[2].destNode = 3;
            tempRoutingTable[2].nextNode = 1;
            tempRoutingTable[2].cost = 1;
            tempRoutingTable[2].flag = 1;
            tempRoutingTable[3].destNode = 3;
            tempRoutingTable[3].nextNode = 4;
            tempRoutingTable[3].cost = 1;
            tempRoutingTable[3].flag = 1;
            tempRoutingTable[4].destNode = 3;
            tempRoutingTable[4].nextNode = 2;
            tempRoutingTable[4].cost = 1;
            tempRoutingTable[4].flag = 1;
            tempRoutingTable[5].destNode = 2;
            tempRoutingTable[5].nextNode = 1;
            tempRoutingTable[5].cost = 1;
            tempRoutingTable[5].flag = 1;
            tempRoutingTable[6].destNode = 2;
            tempRoutingTable[6].nextNode = 3;
            tempRoutingTable[6].cost = 1;
            tempRoutingTable[6].flag = 1;
            tempRoutingTable[7].destNode = 2;
            tempRoutingTable[7].nextNode = 5;
            tempRoutingTable[7].cost = 1;
            tempRoutingTable[7].flag = 1;
            tempRoutingTable[8].destNode = 4;
            tempRoutingTable[8].nextNode = 3;
            tempRoutingTable[8].cost = 1;
            tempRoutingTable[8].flag = 1;
            tempRoutingTable[9].destNode = 4;
            tempRoutingTable[9].nextNode = 6;
            tempRoutingTable[9].cost = 1;
            tempRoutingTable[9].flag = 1;
            tempRoutingTable[10].destNode = 5;
            tempRoutingTable[10].nextNode = 2;
            tempRoutingTable[10].cost = 1;
            tempRoutingTable[10].flag = 1;
            tempRoutingTable[11].destNode = 6;
            tempRoutingTable[11].nextNode = 4;
            tempRoutingTable[11].cost = 1;
            tempRoutingTable[11].flag = 1;
            tempRoutingTable[12].destNode = 3;
            tempRoutingTable[12].nextNode = 5;
            tempRoutingTable[12].cost = 1;
            tempRoutingTable[12].flag = 1;
            tempRoutingTable[13].destNode = 5;
            tempRoutingTable[13].nextNode = 3;
            tempRoutingTable[13].cost = 1;
            tempRoutingTable[13].flag = 1;

            //dbg(ROUTING_CHANNEL, "FIN (CSRT)     routeTempTable.size [%d]\n", call routeTempTable.size());

            call Routing.createPermRouteTable();
            break;
        case 2:
            dbg(ROUTING_CHANNEL, "In createStaticRoutingTable for Node[%d]\n", TOS_NODE_ID);
            permRoutingTable[1].destNode = 1;
            permRoutingTable[1].nextNode = 1;
            permRoutingTable[2].destNode = 2;
            permRoutingTable[2].nextNode = 2;
            permRoutingTable[3].destNode = 3;
            permRoutingTable[3].nextNode = 3;
            permRoutingTable[4].destNode = 4;
            permRoutingTable[4].nextNode = 3;
            permRoutingTable[5].destNode = 5;
            permRoutingTable[5].nextNode = 5;
            permRoutingTable[6].destNode = 6;
            permRoutingTable[6].nextNode = 3;
            break;
        case 3:
            dbg(ROUTING_CHANNEL, "In createStaticRoutingTable for Node[%d]\n", TOS_NODE_ID);
            permRoutingTable[1].destNode = 1;
            permRoutingTable[1].nextNode = 1;
            permRoutingTable[2].destNode = 2;
            permRoutingTable[2].nextNode = 2;
            permRoutingTable[3].destNode = 3;
            permRoutingTable[3].nextNode = 3;
            permRoutingTable[4].destNode = 4;
            permRoutingTable[4].nextNode = 4;
            permRoutingTable[5].destNode = 5;
            permRoutingTable[5].nextNode = 5;
            permRoutingTable[6].destNode = 6;
            permRoutingTable[6].nextNode = 4;
            break;
        case 4:
            dbg(ROUTING_CHANNEL, "In createStaticRoutingTable for Node[%d]\n", TOS_NODE_ID);
            permRoutingTable[1].destNode = 1;
            permRoutingTable[1].nextNode = 3;
            permRoutingTable[2].destNode = 2;
            permRoutingTable[2].nextNode = 3;
            permRoutingTable[3].destNode = 3;
            permRoutingTable[3].nextNode = 3;
            permRoutingTable[4].destNode = 4;
            permRoutingTable[4].nextNode = 4;
            permRoutingTable[5].destNode = 5;
            permRoutingTable[5].nextNode = 3;
            permRoutingTable[6].destNode = 6;
            permRoutingTable[6].nextNode = 6;
            break;
        case 5:
            dbg(ROUTING_CHANNEL, "In createStaticRoutingTable for Node[%d]\n", TOS_NODE_ID);
            permRoutingTable[1].destNode = 1;
            permRoutingTable[1].nextNode = 2;
            permRoutingTable[2].destNode = 2;
            permRoutingTable[2].nextNode = 2;
            permRoutingTable[3].destNode = 3;
            permRoutingTable[3].nextNode = 3;
            permRoutingTable[4].destNode = 4;
            permRoutingTable[4].nextNode = 3;
            permRoutingTable[5].destNode = 5;
            permRoutingTable[5].nextNode = 5;
            permRoutingTable[6].destNode = 6;
            permRoutingTable[6].nextNode = 3;
            break;
        case 6:
            dbg(ROUTING_CHANNEL, "In createStaticRoutingTable for Node[%d]\n", TOS_NODE_ID);
            permRoutingTable[1].destNode = 1;
            permRoutingTable[1].nextNode = 4;
            permRoutingTable[2].destNode = 2;
            permRoutingTable[2].nextNode = 4;
            permRoutingTable[3].destNode = 3;
            permRoutingTable[3].nextNode = 4;
            permRoutingTable[4].destNode = 4;
            permRoutingTable[4].nextNode = 4;
            permRoutingTable[5].destNode = 5;
            permRoutingTable[5].nextNode = 4;
            permRoutingTable[6].destNode = 6;
            permRoutingTable[6].nextNode = 6;
            break;
        default:
            dbg(ROUTING_CHANNEL, "In extra createStaticRoutingTable for Node[%d]\n", TOS_NODE_ID);
            break;
        }

        return SUCCESS;
    }

    command error_t Routing.addToTempTable(uint16_t destination, uint16_t hopNode, uint16_t costIn){
        // dbg(ROUTING_CHANNEL, "In addToTempTable for Node[%d]\n", TOS_NODE_ID);
        // dbg(FLOODING_CHANNEL, "h->currentNode = [%d]\n", destination);
        // dbg(FLOODING_CHANNEL, "h->neighbor = [%d]\n", hopNode);
        // dbg(FLOODING_CHANNEL, "h->cost = [%d]\n", costIn);

        if ((index > sizeof(tempRoutingTable) / sizeof(*tempRoutingTable))) {}// future add a && (check if table flags have been cleared)
        else {
            tempRoutingTable[index].destNode = destination;
            tempRoutingTable[index].nextNode = hopNode;
            tempRoutingTable[index].cost = costIn;
            tempRoutingTable[index].flag = 1;
            index++;
            //call Routing.printRouteTable();
        }
        return SUCCESS;
    }
    
    command error_t Routing.initiateRouting(uint16_t destination, uint8_t TTL, uint16_t seqIN, uint8_t *payload) {
        // dbg(ROUTING_CHANNEL, "\n");
        // dbg(ROUTING_CHANNEL, "In initiateRouting \n");
        //dbg(ROUTING_CHANNEL, "I'm sending the packet from [%d] to [%d]\n", TOS_NODE_ID, destination); // added for demo
        // call Routing.printRouteTable(); //added for demo
        dbg(ROUTING_CHANNEL, "ROUTING   | [IN NODE %d] Packet being sent from NODE [%d] -> NODE [%d]\n", TOS_NODE_ID, TOS_NODE_ID, destination); // added for demo

        makeRoutePack(&sendPackage, TOS_NODE_ID, destination, TTL-1, PROTOCOL_ROUTING, seqIN, payload, PACKET_MAX_PAYLOAD_SIZE);
        
        if (permRoutingTable[destination].flag == 1){
            call RouteSend.send(sendPackage, permRoutingTable[destination].nextNode);
            return SUCCESS;
        }
        else if (permRoutingTable[destination].flag == 0)
            dbg(ROUTING_CHANNEL, "Connection w/ node[%d] is down\n", permRoutingTable[destination]);
        
        //call RouteSend.send(sendPackage, call routeHashTable.get(destination));
        return FAIL;
    }

    command error_t Routing.routeRecieve(message_t* msg, void* payload) {
        pack* myMsg=(pack*) payload;

        if (myMsg->dest == TOS_NODE_ID){
            // dbg(ROUTING_CHANNEL, "From[%d]\n", myMsg->src);
            // dbg(ROUTING_CHANNEL, "destination[%d]\n", myMsg->dest);
            if (myMsg->protocol == PROTOCOL_ROUTING){
                //dbg(ROUTING_CHANNEL, "Final Destination reached, Resending to source [%d]\n", myMsg->src); // gets to here but does not send backwards
                //dbg(ROUTING_CHANNEL, "payload is []\n",myMsg->payload);
                //makeRoutePack(&sendPackage, myMsg->dest, myMsg->src, myMsg->TTL-1, PROTOCOL_ROUTING_BACK, myMsg->seq, myMsg->payload, PACKET_MAX_PAYLOAD_SIZE);
                //dbg(ROUTING_CHANNEL, "routeHashTable.get[%d]\n", permRoutingTable[myMsg->src].nextNode);
                //dbg(ROUTING_CHANNEL, "destination[%d]\n", myMsg->src);
                
                //call RouteSend.send(sendPackage, permRoutingTable[myMsg->src].nextNode); // does not hit (execute) this line
                //dbg(ROUTING_CHANNEL, "past send\n");

                //dbg(ROUTING_CHANNEL, "FINAL DESTINATION REACHED\n");
                
                call Transport.processPacket(myMsg->src, payload);

                return SUCCESS;
            }
            else if (myMsg->protocol == PROTOCOL_ROUTING_BACK){
                dbg(ROUTING_CHANNEL, "Returned to Source\n");
                return SUCCESS;
            }
            else
                return FAIL;
        }
        else if (myMsg->TTL > 0){
            //dbg(ROUTING_CHANNEL, "I'm sending the packet from [%d]\n", TOS_NODE_ID); // added for demo
            //call Routing.printRouteTable(); //added for demo
            dbg(ROUTING_CHANNEL, "ROUTING   | [IN NODE %d] Packet being sent from NODE [%d] -> NODE [%d]\n", TOS_NODE_ID, myMsg->src, myMsg->dest); // added for demo
            
            makeRoutePack(&sendPackage, myMsg->src, myMsg->dest, myMsg->TTL-1, myMsg->protocol, myMsg->seq, myMsg->payload, PACKET_MAX_PAYLOAD_SIZE);
            call RouteSend.send(sendPackage, permRoutingTable[myMsg->dest].nextNode);
            // dbg(ROUTING_CHANNEL, "past else if send\n");
            return SUCCESS;
        }

        return FAIL;
    }

    // this is for creating the routing table
    // command error_t Routing.discoverAndFlood() {
    //     //dbg(ROUTING_CHANNEL, "In discoverAndFlood for Node[%d]\n", TOS_NODE_ID);
    //     return SUCCESS;
    // }

    // dijkstra algorithmn implementation
    // This will be converted into a method which should be called from a Timer on a periodic basis
    // Temp table will be populated based on packets recieved from flood
    // This algorithm will continue to process them and update the table if relevant
    command error_t Routing.createPermRouteTable(){
        uint32_t i;
        uint32_t id;
        uint32_t size;
        uint32_t tempSize = 20;
        size = elementCounter();
        //dbg(ROUTING_CHANNEL, "in createPermRouteTable\n");
        //dbg(ROUTING_CHANNEL, "Loop length: [%d]\n", size);
        while(size != 0){
        //while(tempSize > 0){
            //tempSize--;
            size = elementCounter();
            //dbg(ROUTING_CHANNEL, "size: [%d]\n", size);
            for(i=0; i<sizeof(tempRoutingTable) / sizeof(*tempRoutingTable); i++){ // need to change the hardcoded 11 to the number of elements in the temptable that have proper value
                //dbg(ROUTING_CHANNEL, "[%d].destNode = %d, [%d].nextNode = %d, [%d].cost = %d, [%d].flag = %d\n", i, tempRoutingTable[i].destNode, i, tempRoutingTable[i].nextNode, i, tempRoutingTable[i].cost, i, tempRoutingTable[i].flag);
                if ((tempRoutingTable[i].destNode == tempRoutingTable[i].nextNode) && (tempRoutingTable[i].flag != 0)){
                    permRoutingTable[tempRoutingTable[i].destNode].destNode = tempRoutingTable[i].destNode;
                    permRoutingTable[tempRoutingTable[i].destNode].nextNode = tempRoutingTable[i].nextNode;
                    permRoutingTable[tempRoutingTable[i].destNode].cost = tempRoutingTable[i].cost;
                    permRoutingTable[tempRoutingTable[i].destNode].flag = 1;
                    permRoutingTable[tempRoutingTable[i].destNode].age = ageVal;
                    tempRoutingTable[i].flag = 0;
                    //size--;
                }
                else if((tempRoutingTable[i].nextNode == TOS_NODE_ID) && (tempRoutingTable[i].flag != 0)){
                    tempRoutingTable[i].flag = 0;
                    //size--;
                }
                else if (permRoutingTable[tempRoutingTable[i].nextNode].flag == 1){ // exists in permTable
                    if (permRoutingTable[tempRoutingTable[i].destNode].flag == 0){
                        permRoutingTable[tempRoutingTable[i].destNode].destNode = tempRoutingTable[i].destNode;
                        
                        if (permRoutingTable[tempRoutingTable[i].nextNode].destNode == permRoutingTable[tempRoutingTable[i].nextNode].nextNode)
                            permRoutingTable[tempRoutingTable[i].destNode].nextNode = tempRoutingTable[i].nextNode;
                        else {
                            id = tempRoutingTable[i].nextNode;
                            while(permRoutingTable[id].destNode != permRoutingTable[id].nextNode){
                                //dbg(ROUTING_CHANNEL, "Loop 1 beg | id[%d]\n", id);
                                id = permRoutingTable[id].nextNode;
                            }
                            //dbg(ROUTING_CHANNEL, "Loop 1 fin | id[%d]\n", id);
                            permRoutingTable[tempRoutingTable[i].destNode].nextNode = id;
                        }

                        permRoutingTable[tempRoutingTable[i].destNode].cost = tempRoutingTable[i].cost + permRoutingTable[tempRoutingTable[i].nextNode].cost;
                        permRoutingTable[tempRoutingTable[i].destNode].flag = 1;
                        permRoutingTable[tempRoutingTable[i].destNode].age = ageVal;
                        tempRoutingTable[i].flag = 0;
                        //size--;
                    }
                    else if(permRoutingTable[tempRoutingTable[i].destNode].flag == 1){ // calc cost and compare
                        if (permRoutingTable[tempRoutingTable[i].destNode].cost > 
                            (tempRoutingTable[i].cost + permRoutingTable[tempRoutingTable[i].nextNode].cost)){
                                permRoutingTable[tempRoutingTable[i].destNode].destNode = tempRoutingTable[i].destNode;
                                //permRoutingTable[tempRoutingTable[i].destNode].nextNode = tempRoutingTable[i].nextNode;

                                if (permRoutingTable[tempRoutingTable[i].nextNode].destNode == permRoutingTable[tempRoutingTable[i].nextNode].nextNode)
                                    permRoutingTable[tempRoutingTable[i].destNode].nextNode = tempRoutingTable[i].nextNode;
                                else {
                                    id = tempRoutingTable[i].nextNode;
                                    while(permRoutingTable[id].destNode != permRoutingTable[id].nextNode){
                                        //dbg(ROUTING_CHANNEL, "Loop 2 beg | id[%d]\n", id);
                                        id = permRoutingTable[id].nextNode;
                                    }
                                    //dbg(ROUTING_CHANNEL, "Loop 2 fin | id[%d]\n", id);
                                    permRoutingTable[tempRoutingTable[i].destNode].nextNode = id;
                                }

                                permRoutingTable[tempRoutingTable[i].destNode].cost = tempRoutingTable[i].cost + permRoutingTable[tempRoutingTable[i].nextNode].cost;
                                permRoutingTable[tempRoutingTable[i].destNode].flag = 1;
                                permRoutingTable[tempRoutingTable[i].destNode].age = ageVal;
                                tempRoutingTable[i].flag = 0;
                                //size--;
                            }
                        else {
                            tempRoutingTable[i].flag = 0; 
                            //size--;  
                        }
                    }
                }
            }
        }

        // dbg(ROUTING_CHANNEL, "temp\n");
        // for(i=0; i<sizeof(tempRoutingTable) / sizeof(*tempRoutingTable); i++){
        //     if (tempRoutingTable[i].flag == 1)
        //         dbg(ROUTING_CHANNEL, "[%d].destNode = %d, [%d].nextNode = %d, [%d].cost = %d, [%d].flag = %d\n", i, tempRoutingTable[i].destNode, i, tempRoutingTable[i].nextNode, i, tempRoutingTable[i].cost, i, tempRoutingTable[i].flag);
        // }

        return SUCCESS;
    }
    // everytime we add a element into the array check if flag is 0 and add there

    command error_t Routing.decrementAge(){
        uint32_t i;
        for(i=0; i<sizeof(permRoutingTable) / sizeof(*permRoutingTable); i++){
            if (permRoutingTable[i].age > 0)
                permRoutingTable[i].age = permRoutingTable[i].age - 1; 
            else{
               permRoutingTable[i].flag = 0; 
            }
        }
        return SUCCESS;
    }

    command error_t Routing.printRouteTable() {
        uint32_t i;
        dbg(ROUTING_CHANNEL, "------------------------ ROUTING TABLE FOR NODE [%d] ------------------------\n", TOS_NODE_ID);
        dbg(ROUTING_CHANNEL, "                                 Perm Table\n");
        for(i=0; i < 23; i++){
            if (permRoutingTable[i].flag == 1)
                dbg(ROUTING_CHANNEL, "[%d].destNode = %d, [%d].nextNode = %d, [%d].cost = %d, [%d].flag = %d, [%d].age = %d\n", 
                    i, permRoutingTable[i].destNode, i, permRoutingTable[i].nextNode, i, permRoutingTable[i].cost, i, permRoutingTable[i].flag, i, permRoutingTable[i].age);
        }
        dbg(ROUTING_CHANNEL, "\n");

        // dbg(ROUTING_CHANNEL, "           Temp Table\n");
        // for(i=0; i < sizeof(permRoutingTable) / sizeof(*permRoutingTable); i++){
        //     if (tempRoutingTable[i].flag == 1)
        //         dbg(ROUTING_CHANNEL, "[%d].destNode = %d, [%d].nextNode = %d, [%d].cost = %d, [%d].flag = %d, [%d].age = %d\n", 
        //             i, tempRoutingTable[i].destNode, i, tempRoutingTable[i].nextNode, i, tempRoutingTable[i].cost, i, tempRoutingTable[i].flag, i, tempRoutingTable[i].age);
        // }
    }

    command uint16_t Routing.getNextHop(uint16_t destination) {
        return permRoutingTable[destination].nextNode;
    }

    // need to alter later in case row element in between is deleted
        // potential sol 1: change to loop all 255 elements
        // potential sol 2: after deletion, move all existing elements up by one
    uint32_t elementCounter(){
        uint32_t val;
        uint32_t i;
        val = 0;
        //dbg(ROUTING_CHANNEL, "in elementCounter\n");
        for(i=0; i<sizeof(tempRoutingTable) / sizeof(*tempRoutingTable); i++){
            if (tempRoutingTable[i].flag == 1){ // changed val to i
                //dbg(ROUTING_CHANNEL, "i[%d], val[%d]\n", i, val);
                val++;
            }
        }
        return val;
    }

    void makeRoutePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
        Package->src = src;
        Package->dest = dest;
        Package->TTL = TTL;
        Package->seq = seq;
        Package->protocol = protocol;
        memcpy(Package->payload, payload, length);
   }
}
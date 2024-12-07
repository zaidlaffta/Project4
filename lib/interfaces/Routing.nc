/**
 * ANDES Lab - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   2023/09/08
 *
 */
interface Routing{
   // Events
   // below method to be commented out when neighbordiscovery and dijkstra implemented
   command error_t createStaticRoutingTable();

   command error_t addToTempTable(uint16_t destination, uint16_t hopNode, uint16_t costIn);

   command error_t initiateRouting(uint16_t destination, uint8_t TTL, uint16_t seqIN, uint8_t *payload);

   command error_t routeRecieve(message_t* msg, void* payload);

   command error_t printRouteTable();

   command error_t createPermRouteTable();

   command error_t decrementAge();

   command uint16_t getNextHop(uint16_t destination);
   
   //command error_t discoverAndFlood();
}

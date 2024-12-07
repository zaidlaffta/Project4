interface CommandHandler{
   // Events
   event void ping(uint16_t destination, uint8_t *payload);
   event void printNeighbors();
   event void printRouteTable();
   event void printLinkState();
   event void printDistanceVector();
   event void setTestServer(uint8_t port);
   event void setTestClient(uint16_t destination, uint8_t srcPort, uint destPort, uint16_t transfer);
   event void setAppServer();
   event void setAppClient();
   event void flood(uint16_t destination, uint8_t TTL, uint16_t seqIN, uint8_t *payload); // created for Project 1 (Flooding)
   event void route(uint16_t destination, uint8_t TTL, uint16_t seqIN, uint8_t *payload); // created for Project 2 (Routing)
   event void serverConnection(uint8_t clientPort, char *payload);
   event void broadcastMsg(char *payload);
}

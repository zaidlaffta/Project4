#include "../../includes/packet.h"

interface NeighborDiscovery {
    command error_t postSendTask();
    command error_t receivedNeighborPack(message_t* myMsg, void* payload);
    event void passNeighbor(uint16_t neighborID, uint16_t cost, uint8_t *payload);
}
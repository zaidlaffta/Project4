/**
 * ANDES Lab - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   2023/09/08
 *
 */
interface Flooding{
    command error_t floodHandle(uint16_t destination, uint8_t TTL, uint16_t seqIN, uint8_t *payload);

    //event error_t passNeighbor(uint16_t neighborID, uint16_t cost, uint8_t *payload);
    //command error_t passNeighbor(uint16_t neighborID, uint16_t cost, uint8_t *payload);

    command error_t floodRecieve(message_t* msg, void* payload);
}

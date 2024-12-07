#ifndef __SOCKET_H__
#define __SOCKET_H__

enum{
    MAX_NUM_OF_SOCKETS = 20,
    ROOT_SOCKET_ADDR = 255,
    ROOT_SOCKET_PORT = 255,
    SOCKET_BUFFER_SIZE = 128,
};

enum socket_state{
    CLOSED,
    PASSIVE_OPEN,
    LISTEN,
    ESTABLISHED,
    SYN_SENT,
    SYN_RCVD,
    INIT_CLOSE
};


typedef nx_uint8_t nx_socket_port_t;
typedef uint8_t socket_port_t;

// socket_addr_t is a simplified version of an IP connection.
typedef nx_struct socket_addr_t{
    nx_socket_port_t port;
    nx_uint16_t addr;
}socket_addr_t;


// File descripter id. Each id is associated with a socket_store_t
typedef uint8_t socket_t;

// State of a socket. 
typedef struct socket_store_t{
    uint8_t flag;
    enum socket_state state;
    socket_addr_t src; // client
    socket_addr_t dest; // server

    // This is the sender portion. (client)
    uint16_t sendBuff[SOCKET_BUFFER_SIZE];
    uint8_t lastWritten;
    uint8_t lastAck; // last ack sent
    uint8_t lastSent; // last seq num sent

    // This is the receiver portion. (server)
    uint16_t rcvdBuff[SOCKET_BUFFER_SIZE];
    uint8_t lastRead;
    uint8_t lastRcvd; // last ack recieved
    uint8_t nextExpected; // next seq num expected

    // Added to keep track of sequence number -> sendBuff index (location)
    uint8_t firstDataSeqExpected;
    uint64_t maxByteTransfer;
    uint64_t bytesSent;
    uint64_t bytesTransfered; // will be incrementing (ackknowledged)
    uint16_t position;

    uint16_t lastSeq;
    uint16_t congestionControl;
    uint16_t iterator;

    uint16_t RTT;
    uint8_t effectiveWindow;
    
    uint64_t dataVal;
}socket_store_t;

#endif

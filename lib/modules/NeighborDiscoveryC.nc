configuration NeighborDiscoveryC {
   provides interface NeighborDiscovery;
}

implementation {
   components NeighborDiscoveryP;
   NeighborDiscovery = NeighborDiscoveryP.NeighborDiscovery;
   components new AMReceiverC(AM_PACK) as GeneralReceive;

   components new TimerMilliC() as sendTimer;
   NeighborDiscoveryP.sendTimer -> sendTimer;

   components new HashmapC(uint16_t, 20) as packetsReceived;
   NeighborDiscoveryP.packetsReceived -> packetsReceived;

   components new HashmapC(uint16_t, 20) as packetsSent;
   NeighborDiscoveryP.packetsSent -> packetsSent;

   components new HashmapC(uint16_t, 20) as lastSeqNum;
   NeighborDiscoveryP.lastSeqNum -> lastSeqNum;

   components new HashmapC(float, 20) as linkQuality;
   NeighborDiscoveryP.linkQuality -> linkQuality;

   components new SimpleSendC(AM_PACK);
   NeighborDiscoveryP.Sender -> SimpleSendC;

   components FloodingC;
   NeighborDiscoveryP.Flooder -> FloodingC;
}

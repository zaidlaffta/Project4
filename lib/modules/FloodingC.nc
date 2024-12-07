/**
 * ANDES Lab - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   2023/09/08
 *
 */
configuration FloodingC{
   provides interface Flooding;
}

implementation{
   components FloodingP;
   Flooding = FloodingP.Flooding;

   components new SimpleSendC(AM_PACK);
   FloodingP.FloodSend -> SimpleSendC;

   components NeighborDiscoveryC;
   FloodingP.NeighborDiscovery -> NeighborDiscoveryC;

   components RoutingC;
   FloodingP.Router -> RoutingC;

   // as an example :
   // components FloodingC;
   // NeighborDiscoveryP.Flooder -> FloodingC;

   components new HashmapC(uint32_t, 64) as SeqHashC;
   FloodingP.SeqHash -> SeqHashC;
}

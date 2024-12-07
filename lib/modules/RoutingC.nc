/**
 * ANDES Lab - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   2023/10/08
 *
 */
configuration RoutingC{
   provides interface Routing;
}

implementation{
   components RoutingP;
   Routing = RoutingP.Routing;

   components new SimpleSendC(AM_PACK);
   RoutingP.RouteSend -> SimpleSendC;

   components TransportC;
   RoutingP.Transport -> TransportC;

   // components new HashmapC(uint32_t, 64) as routeHashTableC;
   // RoutingP.routeHashTable -> routeHashTableC;

   // components new HashmapC(uint32_t, 64) as routeCostTableC;
   // RoutingP.routeCostTable -> routeCostTableC;

   // components new HashmapC(uint32_t, 64) as routeTempTableC;
   // RoutingP.routeTempTable -> routeTempTableC;

   // components new HashmapC(uint32_t, 64) as tempCostTableC;
   // RoutingP.tempCostTable -> tempCostTableC;
}

/**
 * CSE 160 - University of California, Merced
 *
 * @author Raivat Alwar
 * @date   09/15/2023
 *
 */
module LinkLayerP {
    provides interface LinkLayer;

    uses interface SimpleSend;
}

implementation {
    command error_t LinkLayer.getSrcAddr(pack msg, uint16_t dest) {
        return FAIL;
    }
    command error_t LinkLayer.getDstAddr(pack msg, uint16_t dest) {
        return FAIL;
    }
}
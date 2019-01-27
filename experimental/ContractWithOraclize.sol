pragma solidity ^0.5.0;
import "./usingOraclize.sol";

contract ContractWithOraclize is usingOraclize {

    string public ETHXBT;
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);

    constructor() public payable {
        emit LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function __callback( string memory result) public {
        if (msg.sender != oraclize_cbAddress()) revert("Not authorized");
        ETHXBT = result;
        
        emit LogPriceUpdated(result);
    }

    function updatePrice() public payable {
        if (oraclize_getPrice("URL") > address(this).balance) {
            emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0");
        }
    }
}
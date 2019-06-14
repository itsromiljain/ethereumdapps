pragma solidity >=0.4.21 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/NotarizedDocument.sol";

contract TestNotarizedDocument {

    NotarizedDocument notarizedDocument = NotarizedDocument(DeployedAddresses.NotarizedDocument());

    function testCheckDocument() public {
        string memory document = "HelloWorld";
        notarizedDocument.notarize(document);
        bool returnValue = notarizedDocument.checkDocument(document);
        Assert.equal(returnValue, true, "The documents should match");
    }

    function testCheckDocumentNegative() public {
        string memory document = "HelloWorld!";
        bool returnValue = notarizedDocument.checkDocument(document);
        Assert.equal(returnValue, false, "The documents should not match");
    }

}

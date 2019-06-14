pragma solidity >=0.4.0 <0.7.0;

contract NotarizedDocument {
    
    mapping (bytes32 => bool) documentProof;
    
    function notarize(string memory document) public {
        bytes32 signedDocument = signDoc(document);
        storeDocumentProof(signedDocument);
    }
    
    function signDoc(string memory document) private pure returns (bytes32) {
        return keccak256(bytes(document));
    }
    
    function storeDocumentProof(bytes32 signedDocument) private {
        documentProof[signedDocument] = true;
    }
    
    function checkDocument (string memory document) public view returns (bool) {
        bytes32 signedDocument = signDoc(document);
        return hasProof(signedDocument);
    }
    
    function hasProof(bytes32 signedDocument) private view returns (bool) {
        return documentProof[signedDocument];
    }
}
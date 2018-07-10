pragma solidity ^0.4.24;

// Proof of Existence contract, version 3
contract ProofOfExistence3 {
 
  mapping (bytes32 => bool) private proofs;

  // store proof
  function storeProof(bytes32 proof) {
    proofs[proof] = true;
  }

  // calculate and store the proof for a document
  function notarize(string document) {
    bytes32 proof = proofFor(document);
    storeProof(proof);
  }

  // helper function to get a document's sha256
  function proofFor(string document) constant returns (bytes32) {
    return sha256(document);
  }

  // check if a document has been notarize
  function checkDocument(string document) constant returns (bool) {
    bytes32 proof = proofFor(document);
    return hasProof(proof);
  }

  // returns true if proof is stored
  function hasProof(bytes32 proof) constant returns (bool) {
    return proofs[proof];
  }
}

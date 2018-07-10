pragma solidity ^0.4.24;

contract Voting {

// Need Candidate List
bytes32[] public candidateList;

mapping (bytes32 => uint8) public votes;

  function Voting(bytes32[] candidateNames) public {
    // constructor
    candidateList = candidateNames;
  }

  function totalVotesFor(bytes32 candidateName) constant public returns (uint8) {
    require(validateCandidate(candidateName));
    return votes[candidateName];
  }

  function castVoteFor(bytes32 candidateName) public {
    require(validateCandidate(candidateName));
    votes[candidateName] += 1;
  }

  function validateCandidate(bytes32 candidateName) constant public returns(bool) {
    for(uint i=0; i<candidateList.length; i++) {
       if(candidateList[i] == candidateName) {
         return true;
       }
    }
    return false;
  }
}

//var ConvertLib = artifacts.require("./ConvertLib.sol");
//var MetaCoin = artifacts.require("./MetaCoin.sol");
//var ProofOfExistence1 = artifacts.require("./ProofOfExistence1.sol");
//var ProofOfExistence2 = artifacts.require("./ProofOfExistence2.sol");
//var MyToken =  artifacts.require("./MyToken.sol");
var VotingContract =  artifacts.require("./Voting.sol");

module.exports = function(deployer) {
  /*deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
  deployer.deploy(ProofOfExistence1);
  deployer.deploy(ProofOfExistence2);
  deployer.deploy(MyToken);*/
  deployer.deploy(VotingContract, ['Rama', 'Nick', 'Jose'], {gas:4700000});
};

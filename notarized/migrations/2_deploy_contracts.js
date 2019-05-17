var NotarizedDocument = artifacts.require("NotarizedDocument");

module.exports = function(deployer) {
  deployer.deploy(NotarizedDocument);
};

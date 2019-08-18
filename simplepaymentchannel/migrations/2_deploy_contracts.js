var SimplePaymentChannel = artifacts.require("SimplePaymentChannel");

module.exports = function(deployer) {
  deployer.deploy(SimplePaymentChannel);
};

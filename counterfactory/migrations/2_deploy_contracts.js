const CounterFactory = artifacts.require("CounterFactory");

module.exports = function(deployer) {
  deployer.deploy(CounterFactory);
};

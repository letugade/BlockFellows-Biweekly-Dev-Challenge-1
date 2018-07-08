module.exports = function(deployer) {
  // Use deployer to state migration tasks.
  const Delivery = artifacts.require('Delivery');
  deployer.deploy(Delivery);
};

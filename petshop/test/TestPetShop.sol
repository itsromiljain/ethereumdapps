pragma solidity >=0.4.21 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PetShop.sol";

contract TestPetShop {

    PetShop petShop = PetShop(DeployedAddresses.PetShop());

    uint expectedPetId = 8;

    address expectedAdopter = address(this);

    function testUserCanAdoptPet() public {
        uint returnPetId = petShop.adopt(expectedPetId);
        Assert.equal(returnPetId, expectedPetId, "Adoption of the expected pet should match what is returned.");
    }

    function testGetAdopterAddressByPetId() public {
        address adopter = petShop.adopters(expectedPetId);
        Assert.equal(adopter, expectedAdopter, "Owner of the expected pet should be this contract");
    }

    function testGetAllAdopterAddresses() public {
        address[16] memory adopters = petShop.getAdopters();
        Assert.equal(adopters[expectedPetId], expectedAdopter, "Owner of the expected pet should be this contract");
    }
}
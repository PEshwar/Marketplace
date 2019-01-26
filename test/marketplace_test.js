const hex2ascii = require('hex2ascii')

var Marketplace = artifacts.require('Marketplace')

//Test contract to test functions of Marketplace contract

contract('Marketplace', function(accounts) {

    var owner = accounts[0];
    var adminAddress = accounts[1];
    var storeOwnerAddress = accounts[2];
    // The following two addresses should be replaced by 
   // var adminAddress = "0xa4e7466f2E8018cDd87C8fB3971e9566FfdCb3eE";
   // var storeOwnerAddress = "0x494519E976162901e574b86f3727A9BaEeE8512F";

/* Test 1 - Checks if owner of contract is able to add a new admin to marketplace
* Also checks if corresponding event is generated */

it("Owner should be able to add admin", async() => {
        const marketplace = await Marketplace.deployed()


	const tx = await marketplace.addAdmin(adminAddress,  {from: owner})

    if (tx.logs[0].event) {
	//	sku = tx.logs[0].args.sku.toString(10)
		eventEmitted = true
	}
        
    const role = await marketplace.roles(adminAddress)

    assert.equal(hex2ascii(role), "Admin", 'the role added is not admin')
    assert.equal(eventEmitted, true, 'Adding admin should emit an AdminAdded event')

})    



/* Test 2 - Checks if owner of contract is able to remove a particular address with admin role from marketplace
* Also checks if corresponding event is generated */

it("Owner should be able to remove admin", async() => {
    const marketplace = await Marketplace.deployed()


    const tx = await marketplace.removeAdmin(adminAddress,  {from: owner})

    if (tx.logs[0].event) {
        eventEmitted = true
    }
    
    const role = await marketplace.roles(adminAddress)

    assert.equal(hex2ascii(role), "Invalid", 'Admin not removed correctly')
    assert.equal(eventEmitted, true, 'Removing admin should emit an AdminRemoved event')

})

/* Test 3 - Checks if admin of marketplace is able to add an address as store owner
* Also checks if corresponding event is generated */

it("Admin should be able to add Store owner", async() => {
    const marketplace = await Marketplace.deployed()


    const tx = await marketplace.addAdmin(adminAddress,  {from: owner})
    const tx2 = await marketplace.addStoreOwner(storeOwnerAddress, {from: adminAddress})

    if (tx2.logs[0].event) {
    //	sku = tx.logs[0].args.sku.toString(10)
        eventEmitted = true
    }
    
    const role = await marketplace.roles(storeOwnerAddress)

    assert.equal(hex2ascii(role), "StoreOwner", 'StoreOwner role not added correctly')
    assert.equal(eventEmitted, true, 'Adding Storeowner should emit a StoreOwnerAdded event')

})    

/* Test 4 - checks if the admin of marketplace is able to remove an address which has store owner role
* Also checks if corresponding event is generated */

it("Admin should be able to remove Store owner", async() => {
    const marketplace = await Marketplace.deployed()


    const tx = await marketplace.addAdmin(adminAddress,  {from: owner})
    const tx2 = await marketplace.addStoreOwner(storeOwnerAddress, {from: adminAddress})
    const tx3 = await marketplace.removeStoreOwner(storeOwnerAddress, {from: adminAddress})

    if (tx2.logs[0].event) {
    //	sku = tx.logs[0].args.sku.toString(10)
        eventEmitted = true
    }
    
    const role = await marketplace.roles(storeOwnerAddress)

    assert.equal(hex2ascii(role), "Invalid", 'StoreOwner role not removed correctly')
    assert.equal(eventEmitted, true, 'Removing Storeowner should emit a StoreOwnerRemoved event')

})   

/* Test 5 - checks if the store owner is able to add a new store to marketplace
* Also checks if corresponding event is generated */

it("Store owner should be able to add Store ", async() => {
    const marketplace = await Marketplace.deployed()


    const tx = await marketplace.addAdmin(adminAddress,  {from: owner})
    const tx2 = await marketplace.addStoreOwner(storeOwnerAddress, {from: adminAddress})
    const tx3 = await marketplace.addStore(web3.utils.utf8ToHex("Store 1"),web3.utils.utf8ToHex("Store to sell books"), {from: storeOwnerAddress})
    const tx4 = await marketplace.addStore(web3.utils.utf8ToHex("Store 2"),web3.utils.utf8ToHex("Store to sell music"), {from: storeOwnerAddress})
    

    if (tx4.logs[0].event) {
    //	sku = tx.logs[0].args.sku.toString(10)
        eventEmitted = true
    }
    
    const storeIndex = await marketplace.indexOfStores(storeOwnerAddress,web3.utils.utf8ToHex("Store 2"))

    assert.equal(parseInt(storeIndex), 1, 'Store not added correctly')
    assert.equal(eventEmitted, true, 'Adding Store should emit a StoreAdded event')

})



});
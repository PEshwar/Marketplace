pragma solidity ^0.5.0;

contract Marketplace {
    
    using SafeMath for uint;

    //State variables
    address  payable public owner;
    address[] public storeOwners;
    // Shows role associated with a particular address
    mapping(address => bytes32) public roles; 
    // Shows list of stores for store owner
    mapping(address => Store[]) public stores; 
    // Shows index (of store) in stores array for  (store owner + store name )      
    mapping (address => mapping(bytes32 => uint)) public indexOfStores; 
    // Shows sales balance for store owner
    mapping (address => uint) private ownerSalesBalances;

    // Structure of a store
    struct Store {
        bytes32 name;
        bytes32 description;
        bytes32[] productNames;
        mapping(bytes32 => Product)  products; // Address to Storefront to products mapping    
    }

    //Structure of a product
    struct Product  {
        bytes32 name;
        bytes32 description;
        uint price;
        uint stockBalance;
        uint productIndexInStore;
    } 
    
    // Events
    event AdminAdded(address adminAddress, uint time);
    event AdminRemoved(address adminAddress, uint time);
    
    event StoreOwnerAdded(address storeOwner, uint time);
    event StoreOwnerRemoved(address storeOwner, uint time);
    
    event StoreAdded(address storeOwner, bytes32 name, bytes32 description, uint time);
    event StoreRemoved(address storeOwner, bytes32 name, uint time);
    
    event ProductAddedToStore(address storeOwner, bytes32 storeName, bytes32 productName, bytes32 productDesc, uint price, uint stockBalance,uint time );
    event ProductRemovedFromStore(address storeOwner, bytes32 storeName, bytes32 productName, uint time);    
        
    event ProductPurchased(address storeOwner, address buyer, bytes32 storeName, bytes32 productName, uint purchaseQty,  uint time);    
    event StoreOwnerWithdrawsBalance(address storeOwner, uint amount, uint time);
    
    //Functions
    
    //constructor
    constructor() public {
        owner = msg.sender;
        roles[msg.sender] = "Owner";
    }

    // Fallback function- if call does not match any function signature in this contract
    function() external {
        revert("Invalid function call");
    }

    // Function to self-destruct contract and transfer all funds back to owner.
    function destroyContract() public {
        selfdestruct(owner);
   }

    //Implement circuit breaker
    bool public contractPaused = false;
    function circuitBreaker() public  { // onlyOwner can call
        require(owner == msg.sender);
        if (contractPaused == false) { contractPaused = true; }
        else { contractPaused = false; }
    }

    // If the contract is paused, stop the modified function
    // Attach this modifier to all public functions
    modifier checkIfPaused() {
        require(contractPaused == false);
        _;
    }

    //Two functions related to Owner - addAdmin, removeAdmin
    /**
    * @notice Add `newAdmin` as admin.
    * @dev This function adds an admin
    * @param newAdmin - address of admin to add
    */
    function addAdmin(address newAdmin) public checkIfPaused() {
        require(msg.sender == owner, "Not authorized");
        roles[newAdmin] = "Admin";
        emit AdminAdded(newAdmin, block.number);
    }    

    /**
    * @dev This function removes an admin
    * @param admin - address of admin to remove
    */    
    function removeAdmin(address admin) public checkIfPaused() {
        require(msg.sender == owner, "Not authorized");
        roles[admin] = "Invalid"; 
        emit AdminRemoved(admin, block.number);

    }   
    
    // Two functions related to Admin- addStoreOwner, removeStoreOwner, 
    /**
    * @dev This function adds a store owner
    * @param newStoreOwner - address of new store owner
    */       
    function addStoreOwner(address newStoreOwner) public checkIfPaused() {
        require(roles[msg.sender] == "Admin", "Not Authorized");
        roles[newStoreOwner] = "StoreOwner";
        storeOwners.push(newStoreOwner);
        emit StoreOwnerAdded(newStoreOwner, block.number);
    }

    /**
    * @dev This function removes a store owner
    * @param storeOwner - address of store owner to remove
    */    
    function removeStoreOwner(address storeOwner) public checkIfPaused() {
        require(roles[msg.sender] == "Admin", "Not Authorized");
        roles[storeOwner] = "Invalid";
        removeAddress(storeOwner);
        emit StoreOwnerRemoved(storeOwner, block.number);
    }
    
    /* Six functions related to Store Owner - addStore, removeStore, addProductToStore,
    * removeProductFromStore, purchaseItem, withdrawSalesBalance
    */
    /**
    * @dev This function creates a new store. The new store is 
    * added to stores mapping, which maintains list of stores for each 
    * store owner. The index of store added is captured in
    * indexofStores mapping, for ready reference.
    * @param _name - name of the store 
    * @param _description - short description of store
    */
    function addStore(bytes32 _name, bytes32 _description) public checkIfPaused() {
        require(roles[msg.sender] == "StoreOwner", "Not Authorized");
        stores[msg.sender].push(Store({
            name: _name,
            description: _description,
            productNames : new bytes32[](0)
        }));
        indexOfStores[msg.sender][_name] = stores[msg.sender].length - 1;
        emit StoreAdded(msg.sender,_name, _description,block.number);
    }

    /**
    * @dev This function removes a store 
    * @param name - name of store to remove.
    * The store is removed from stores array, and also corresponding index entry is removed in indexOfStores
    */ 
    function removeStore(bytes32 name) public checkIfPaused() {
        require(roles[msg.sender] == "StoreOwner", "Not Authorized");
        uint storeIndex = indexOfStores[msg.sender][name];
        delete stores[msg.sender][storeIndex];
        delete indexOfStores[msg.sender][name];
        emit StoreRemoved(msg.sender,name,block.number);
    }
    
    /**
    * @dev This function adds a new product to store. 
    * Also a new entry is added to productNames array in that store.
    * @param _storeName - name of the store 
    * @param _productName - name of product to add to store
    * @param _productDesc - description of product
    * @param _price - price of product
    * @param _stockBalance - how many units of that product are there in store/inventory
    */
    function addProductToStore(bytes32 _storeName, bytes32 _productName, bytes32 _productDesc, uint _price, uint _stockBalance) 
    public checkIfPaused() {
        require(roles[msg.sender] == "StoreOwner", "Not Authorized");
        Store[] storage storesOwned = stores[msg.sender];
        uint storeIndex = indexOfStores[msg.sender][_storeName]; 
        Store storage thisStore = storesOwned[storeIndex];        
        
        thisStore.products[_productName] = Product({
            name: _productName,
            description: _productDesc,
            price: _price,
            stockBalance : _stockBalance,
            productIndexInStore: thisStore.productNames.length
        });
        thisStore.productNames.push(_productName);
        emit ProductAddedToStore(msg.sender,  _storeName,  _productName, _productDesc, _price, _stockBalance,block.number );    

    }
    
    /**
    * @dev This function removes a product from a store 
    * @param _storeName - name of store from which product has to be removed
    * @param _productName - name of product to be removed from store
    * The product is removed from products array for that store.
    */ 
    function removeProductFromStore(bytes32 _storeName,bytes32 _productName) public checkIfPaused() {

        Store[] storage storesOwned = stores[msg.sender];
        uint storeIndex = indexOfStores[msg.sender][_storeName]; 
        Store storage thisStore = storesOwned[storeIndex];
        
        delete thisStore.products[_productName];
        delete thisStore.productNames[thisStore.products[_productName].productIndexInStore];
        emit ProductRemovedFromStore(msg.sender,_storeName, _productName, block.number);
    }
    
    /**
    * @dev This function enables a user to purchase an item from a store
    * @param _storeOwner - name of store owner 
    * @param _storeName - name of store from which product to be purchased
    * @param _productName - name of product to be removed from store
    * @param _purchaseQty - quantity of product(s) to be purchased
    * The product is removed from products array for that store.
    */ 
    function purchaseItem(address _storeOwner, bytes32 _storeName, bytes32 _productName, uint _purchaseQty) 
    public payable checkIfPaused() {
        
        //Get current product from products array in store         
        uint storeIndex = indexOfStores[_storeOwner][_storeName];        
        Store storage thisStore = stores[_storeOwner][storeIndex];
        Product storage currentProduct = thisStore.products[_productName];
        
        require(_purchaseQty <= currentProduct.stockBalance, "Insufficient stock balance");
        
        uint totalPrice = currentProduct.price * _purchaseQty;
        
        require(msg.value > totalPrice, "Insufficient funds");
        
        ownerSalesBalances[_storeOwner] += totalPrice;
        
        currentProduct.stockBalance -= _purchaseQty;
        
        emit ProductPurchased(_storeOwner, msg.sender, _storeName, _productName, _purchaseQty, block.number);
        
    }

    /**
    * @dev This function enables a storeowner to withdraw his/her sales proceeds
    * The owner sales balance is updated to zero
    */ 
    function withdrawSalesBalance() public checkIfPaused() {
        require (roles[msg.sender] == "StoreOwner", "Not Authorized");
        
        uint amountForWithdrawal = ownerSalesBalances[msg.sender];
        
        ownerSalesBalances[msg.sender] = 0;
        msg.sender.transfer(amountForWithdrawal);
        
        emit StoreOwnerWithdrawsBalance(msg.sender, amountForWithdrawal, block.number);
        
    }

    // Getter functions
    /**
    * @dev This function gets all the stores owned by a particular store owner
    * @param _storeOwner - address of the store owner
    * @param _nextIndex - next index used for iteratively getting all the stores of a particular store owner
    */
    function getAllOwnerStores(address _storeOwner, uint _nextIndex) public 
    view checkIfPaused()
    returns (address, bytes32[5] memory, bytes32[5] memory, uint, bool)    
    {
        address storeOwnerAddr;
        bytes32[5] memory storeNames;
        bytes32[5] memory storeDescription;        
        bool endOfStoresReached;
      
 
        require(roles[msg.sender] == "StoreOwner", "Not authorized");
  
        storeOwnerAddr = _storeOwner;

        Store[] storage ownerStores = stores[_storeOwner]; 
                
        for (uint i = 0; i<5; i++)
        {
            if (_nextIndex + i < ownerStores.length)
            {
                storeNames[i] = ownerStores[_nextIndex + i].name; 
                storeDescription[i] = ownerStores[_nextIndex + i].description;
            }
            else
            {
                endOfStoresReached = true;
                break;
            } 
        }
        uint nextIndex = _nextIndex + 5;
        return (storeOwnerAddr, storeNames, storeDescription, nextIndex, endOfStoresReached);
    }

    /**
    * @dev This function gets all the products in a store
    * @param _storeOwner - address of the store owner
    * @param _storeName - name of the store from which to get products
    * @param _nextIndex - next index used for iteratively getting all the products in the store
    */
    function getProductsInStore(address _storeOwner,bytes32 _storeName,uint _nextIndex) public 
    view checkIfPaused()
    returns (bytes32[5] memory ,uint[5] memory ,uint[5] memory , uint  ,bool  ) {
        uint storeIndex = getStoreIndex(_storeOwner,_storeName);
        return getItemDetails(_nextIndex, _storeOwner, storeIndex);
    }    

    // Utility & helper functions
    /* Commented out for now
    function compareStrings (bytes32  a, bytes32  b) private view returns (bool){
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    } 
    */   
  /**
    * @dev This function gets the details of products in a store. Helper for the 'getProductsInStore' function
    * @param _storeOwner - address of the store owner
    * @param _storeIndex - index of the store
    * @param _nextIndex - next index used for iteratively getting all the items in the store
    */
    function getItemDetails(uint _nextIndex, address _storeOwner, uint _storeIndex)
    private view
    returns (bytes32[5] memory productName , uint[5] memory productPrice, uint[5] memory quantityLeft, uint nextIndex, bool endOfItemsReached) //bytes32 [5],
    {
        Store storage store = stores[_storeOwner][_storeIndex];
        nextIndex = _nextIndex;

        for (uint i = 0; i<5; i++)
        {
            if (nextIndex + i < store.productNames.length)
            {
                Product memory product = store.products[store.productNames[nextIndex + i]];

                productName[i] = product.name; 
                productPrice[i] = product.price;
                quantityLeft[i] = product.stockBalance;
            }
            else
            {
                endOfItemsReached = true;
                break;
            } 
        }

        nextIndex += 5;
    }

    /**
    * @dev This function gets the index of a store form the storeIndices mapping  
    * @param _storeOwner - address of the store owner
    * @param _storeName - name of the store, whose index is to be retrieved
    */    
    function getStoreIndex(address _storeOwner, bytes32 _storeName) public view 
    checkIfPaused() returns(uint){

        return indexOfStores[_storeOwner][_storeName];
    }

    /**
    * @dev This function removes a store owner from storeowners array
    * @param _address - address of store owner to remove
    */     
    function removeAddress(address _address) private {
        uint arrayLength = storeOwners.length;
        address[] memory tempArray = new address[](0);
        for(uint i = 0; i < arrayLength; i++) {
            if(storeOwners[i] != _address) {
                tempArray[i] = storeOwners[i];
            }
            
        }
        storeOwners = tempArray;
    }
    

}

library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract FamilyGroceryList {
    address public owner;
    mapping(address => bool) public isFamilyMember;

    // Grocery item struct
    struct GroceryItem {
        string name;
        uint256 quantity;
    }

    // Mapping: itemName => GroceryItem
    mapping(string => GroceryItem) private groceryItems;

    // Events
    event ItemAdded(string itemName, uint256 quantity, address indexed by);
    event ItemRemoved(string itemName, address indexed by);
    event ItemUpdated(string itemName, uint256 newQuantity, address indexed by);
    

    // Modifier to restrict to family members
    modifier onlyFamilyMember() {
        require(isFamilyMember[msg.sender], "Not a family member");
        _;
    }

    // Constructor: Deployer is the first family member
    constructor() {
        owner = msg.sender;
        isFamilyMember[msg.sender] = true;
    }

    // Add a new grocery item (or update quantity if it exists)
    function addItem(string memory _itemName, uint256 _quantity) external onlyFamilyMember {
        require(_quantity > 0, "Quantity must be greater than 0");
        require(bytes(_itemName).length > 0, "Item name cannot be empty");

        groceryItems[_itemName] = GroceryItem({
            name: _itemName,
            quantity: _quantity
        });

        emit ItemAdded(_itemName, _quantity, msg.sender);
    }

    // Remove an item from the list
    function removeItem(string memory _itemName) external onlyFamilyMember {
        require(groceryItems[_itemName].quantity > 0, "Item does not exist");

        delete groceryItems[_itemName];
        emit ItemRemoved(_itemName, msg.sender);
    }

    // Update the quantity of an existing item
    function updateItemQuantity(string memory _itemName, uint256 _newQuantity) external onlyFamilyMember {
        require(groceryItems[_itemName].quantity > 0, "Item does not exist");
        require(_newQuantity > 0, "Quantity must be greater than 0");

        groceryItems[_itemName].quantity = _newQuantity;
        emit ItemUpdated(_itemName, _newQuantity, msg.sender);
    }

    // Get the quantity of an item
    function getItemQuantity(string memory _itemName) external view returns (uint256) {
        return groceryItems[_itemName].quantity;
    }

    // Add a family member (caller must be a family member)
    function addFamilyMember(address _member) external onlyFamilyMember {
        require(_member != address(0), "Invalid address");
        isFamilyMember[_member] = true;
    }

    // Remove a family member (caller must be a family member)
    function removeFamilyMember(address _member) external onlyFamilyMember {
        require(_member != owner, "Cannot remove owner");
        isFamilyMember[_member] = false;
    }
}
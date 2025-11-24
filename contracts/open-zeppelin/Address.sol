// Upgrade to the current best practice version for built-in security features
// like overflow/underflow checks.
pragma solidity ^0.8.0;

/**
 * @title Address
 * @dev Collection of functions related to the address type, mimicking OpenZeppelin's standard.
 */
library Address {
    /**
     * @dev Returns true if `account` has code deployed.
     *
     * WARNING: It is unsafe to assume that an address returning false is an 
     * externally-owned account (EOA). This check is only definitive if true (it is a contract).
     * It may return false for:
     * - EOA
     * - Contract currently in construction
     * - Destroyed contract
     * - Address where a contract will be created (pre-computed)
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, we check the code hash of the account.
        // The code hash for an EOA or empty account is the hash of an empty string.
        bytes32 codehash;
        
        // This is keccak256('') - the hash for an account with no code.
        bytes32 constant ACCOUNT_HASH_NO_CODE = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        
        // solhint-disable-next-line no-inline-assembly
        assembly { 
            // Use extcodehash to fetch the code hash of the given account address.
            codehash := extcodehash(account) 
        }
        
        // An account is a contract if its codehash is neither the empty hash nor 0x0
        // (which is returned for accounts not yet created).
        return (codehash != ACCOUNT_HASH_NO_CODE && codehash != bytes32(0));
    }

    /**
     * @dev Sends `amount` Wei to `recipient`, forwarding all available gas.
     * Reverts on error. This is the modern, safe replacement for Solidity's `transfer()`.
     *
     * IMPORTANT: Control flow is transferred to `recipient`. Must guard against 
     * reentrancy vulnerabilities by using the Checks-Effects-Interactions pattern.
     * * @param recipient The address to receive the Ether. Must be payable.
     * @param amount The amount of Wei to send.
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        // Require sufficient balance on the contract calling this library.
        require(address(this).balance >= amount, "Address: insufficient balance");

        // The low-level `call` is used instead of `transfer` to avoid the 2300 gas limit 
        // issue (EIP-1884), ensuring the recipient contract can execute logic.
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, ) = recipient.call{ value: amount }("");
        
        // Check if the call was successful (no revert occurred).
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

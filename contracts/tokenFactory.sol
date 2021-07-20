// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;
//pragma experimental ABIEncoderV2;
import "./userToken.sol";
interface IERC20{
     function transfer(address recipient, uint256 amount) external returns (bool);
     function excludeAddress(address _whale) external returns(bool);
      function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
      function balanceOf(address account) external view returns (uint256);
     
}

contract TokenFactory{

    Token[]public userTokens;//all tokens created
    mapping(address=> Token) userToToken;
    
    
    event userTokenCreated(
        address _tokenOwner,
        address _token,
        string tokenName,
        string  symbol,
        uint8 decimals,
        uint256 maxAllowedPercent,
        uint256 date
    );
    
    
    struct Token{
        address _owner;
        address _tokenAddress;
        string _name;
        string _synbol;
        uint8 _decimal;
        uint _maxPercent;
        
    }
    
    function createUserToken(string memory name,
    string memory symbol,
    uint8 decimals,
    uint256 maxAllowedPercent) public {
        
        //create a new TokenContract
        UserToken userToken = new UserToken(name,
         symbol, decimals, maxAllowedPercent);

       
       //save the new created token as Struct
         
         Token memory newToken = Token({
             _owner: msg.sender,
             _tokenAddress: address(userToken),
             _name: name,
             _synbol: symbol,
             _decimal: decimals,
             _maxPercent: maxAllowedPercent
             
         });
         
         // push the new Token to array userTokens
          userTokens.push(newToken);
          
         userToToken[msg.sender] = newToken;
         
         //emit event

         emit userTokenCreated(msg.sender,
            address(userToken),
             name,
              symbol,
              decimals,
               maxAllowedPercent,
               block.timestamp);

    }
    
    
    function allTokens() public view returns(Token[] memory){
        return userTokens;
    }
    
    
    
   

    function allUSerTokens(address _address) public view returns(Token memory){
       return userToToken[_address];
    }
    
    
   
    function exclude_Address(address to_be_excluded) public{
        require(msg.sender == userToToken[msg.sender]._owner, 'you are not the owner');
       address _tokenAddress = userToToken[msg.sender]._tokenAddress;
        IERC20 tokenInstance = IERC20(_tokenAddress);
        
        tokenInstance. excludeAddress(to_be_excluded);
        
    }
    
    function transfer(address _recipient, uint256 _amount) public {
         require(msg.sender == userToToken[msg.sender]._owner, 'you are not the owner');
       address _tokenAddress = userToToken[msg.sender]._tokenAddress;
        IERC20 tokenInstance = IERC20(_tokenAddress);
        
        require(tokenInstance.balanceOf(msg.sender) >= _amount, 'insufficient fund');
        
        tokenInstance.transferFrom(msg.sender, _recipient, _amount);
        
        
    }
    

    

}
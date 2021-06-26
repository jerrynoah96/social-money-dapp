pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;
import "./userToken.sol";

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
               now);

    }
    
    
    function allTokens() public view returns(Token[] memory){
        return userTokens;
    }
    
    
    
   

    function USerToken(address _address) public view returns(Token memory){
       return userToToken[_address];
    }

    function myToken() public view onlyOwner returns(Token memory){
        return userToToken(msg.sender);
    }

    

    

}
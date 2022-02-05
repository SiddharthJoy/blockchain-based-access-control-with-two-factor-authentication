pragma solidity ^0.7.1;

contract Access_Control_Protocol{
    
    uint8 public decimals = 10;
    uint64 public totalSupply;
    uint64 public now = 100;
    address[] public violation;
    uint64 public idx = 0;

    address admin;
    mapping (address => uint64) public balanceOf;
    mapping (address => uint64) public adds;
    mapping (address => uint64) public unauthorizedAccess;
 
    event Transfer(address indexed from, address indexed to, uint64 value);


    function transfer(address _to, uint64 _value) public {
        _transfer( admin, msg.sender, _value);
    }

  
      function _transfer(address _from, address _to, uint64 _value) internal {
        // require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
// }

// contract acces_control is AccessControl_digitalSig
// {
 
uint64 public time_start; 
uint64 public time_end; 
uint64 _uid = 1;

string location;
mapping(address=>role) white_list;
address public ad_device_owner;

enum role{
    Ressource_Owner,NetworkEngineer,Service_Provider,Blaclisted
}

function getMessageHash(string memory _message,uint _nonce) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message, _nonce));
}


function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32){
        return
            keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
}


function verify(address _signer,string memory _message,uint _nonce,bytes memory signature) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
}

function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address){
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
}

function splitSignature(bytes memory sig) public pure returns (bytes32 r,bytes32 s,uint8 v){
        require(sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

function Acces_control(string memory device_location,uint64 access_time_start,uint64 access_time_end,uint64 initialSupply) public { 
        totalSupply = uint64(initialSupply * 10 ** uint64(decimals)); 
        ad_device_owner=msg.sender;
        admin=ad_device_owner;
        white_list[ad_device_owner]=role.Ressource_Owner; 
        time_start=access_time_start;
        time_end=access_time_end;
    
        location=device_location;
        balanceOf[ad_device_owner] = totalSupply;
       
}   


function getViolationHistory()public view returns( address  [] memory){
    return violation;
}


   modifier only_ressource_owner() 
    {
        require(white_list[msg.sender]==role.Ressource_Owner);
        _;
    }


event allow_access_event(bool allowed);

    function setRole (address ad, uint64  roleID) public only_ressource_owner 
    {

        if (roleID==0)
            white_list[ad]=role.Ressource_Owner;   
        if (roleID==1)
            white_list[ad]=role.NetworkEngineer;  
        if (roleID==2)
            white_list[ad]=role.Service_Provider; 
        if (roleID==3)
            white_list[ad]=role.Blaclisted; 
        
    }

 
    function getrole(address ad) public only_ressource_owner view returns (string memory) 
    {
        if(white_list[ad] == role.Ressource_Owner) return "RO";
        if(white_list[ad] == role.NetworkEngineer) return "Network Engineer";
        if(white_list[ad] == role.Service_Provider) return "Service Provider";
        if(white_list[ad] == role.Blaclisted) return "Blacklisted";
        //return ;
    }
    
    function get_token_balance(address ad) public only_ressource_owner view returns(uint64)
    {
        // return balanceOf[ad];
        return unauthorizedAccess[ad];
    }


function access_control_policy(address requester, string memory location_,bytes memory signature)public returns (bool) { 
    
    string memory loc = "serverroom";
    
    if(keccak256(abi.encodePacked((location_))) == keccak256(abi.encodePacked((loc))) && now <= time_end && now >= time_start)
    {
                bytes32 messageHash = getMessageHash(location_, _uid); 
                if(verify(msg.sender,location_,_uid,signature) == true){
                    transfer(requester,1);
                    allow_access_event(true);
                    _uid++;
                    return true;
                }
                else{
                    unauthorizedAccess[requester]++;
                    _uid++;
                    if(unauthorizedAccess[requester] == 3){
                         white_list[requester]=role.Blaclisted; 
                        unauthorizedAccess[requester] = 0;
                    }
                 return true;
                }
    }
    else {
        unauthorizedAccess[requester]++;
        _uid++;
        if(unauthorizedAccess[requester] == 3){
            white_list[requester]=role.Blaclisted;
            violation[idx++] = requester; 
            adds[requester]++;
            unauthorizedAccess[requester] = 0;
        }
        return true;
    }
}

function Access_Request(string memory ressource_, string memory location,bytes memory signature) public returns (bool){ 
     string memory res = "raspberry";
    if(keccak256(abi.encodePacked((ressource_))) == keccak256(abi.encodePacked((res))) && white_list[msg.sender] == role.NetworkEngineer || white_list[msg.sender]==role.Ressource_Owner)
    {
        if(access_control_policy(msg.sender, location, signature)) return true;
        return false;
    }
     else{
         revert();
     }
}

function token_back(uint64 amount) public{
    _transfer(msg.sender,ad_device_owner,amount);
}

}


// ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)

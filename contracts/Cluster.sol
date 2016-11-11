/***************************************************************************
    
    Copyright (c) 2016-2018  |  Nebulis Foundation

    Released under The MIT Licence.

    All rights reserved. This software is subject to updates, and is provided 
    without warranty of any kind, express or implied. Use at own risk.

    Permission is hereby granted to any person obtaining copy of this software 
    and associated documentation to use, copy, merge, publish and distribute 
    this software without restriction or charge.

 **************************************************************************/

pragma solidity ^0.4.2;

import "Node.sol";
import "Parser.sol";
import "Who.sol";

contract Cluster is Curated {

    using Parser for *;
    /** 
     * @dev the valid oxes available within a particular cluster. By default ipfs:// and /ipfs/ are active,
     * but others protocol oxes can be added for other protocols, for example swarm or even http-mappings.
     * Note: maps the ox string ("ipfs://") to an "activated" bool (true) to the string-length of the ox (7)
    **/

/// @dev the cluster domain string
    bytes32 public cd;

/// @dev the address of the "curated" action contact
    address public curated;

/// @dev the address of the root database
    address public root;

/// @dev the address of the library
    address public parser;
    
/// @dev the number of activated grammars in the parser (set by the cluster) 
    uint[] public grammars;

    /**
     * The following two mappings deal with whether a given character is part of the valid set
     * The "module" mapping numbers the grammar sets from 1-7, where 7 is the custom and 1-6 are given options
    **/    

    mapping(bytes1 => bool) set;
    mapping(uint => bytes) module;

    mapping(bytes32 => address) reserved;

/// @dev the modules struct contains pre-given options 1-6 as well as an option 7 for custom grammar sets
    struct modules {
        bytes latinbasic;
        bytes digits;
        bytes punctuation;
        bytes arithmetic;
        bytes latinextended;
        bytes currency;
        bytes custom;
    }

/// @dev an iteration of "modules" in storage  
    modules public regex;


/// @dev only the "curated" action contract can pass the following guard
    modifier checkOnlyCurated {
        if(msg.sender != curated) throw;
        _;
    }

/// @dev a modifier to check whether a grammar set has already been installed
    modifier alreadyInstalled(uint _module) {
        if(module[_module].length != 0) throw;
        _;
    }

    
    function Cluster(bytes32 _cd, address _parser, address[] _curators) {
//  set the cluster domain
        cd = _cd;

//  create new root contract
        root = new Root(this, _parser, _cd);

//  create new curated contract which assigns initial curators
        address curated = new Curated(_curators);

// define all the default grammar sets available to activate
        regex.latinbasic = "\x45\x2d\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a";
        regex.digits = "\x30\x31\x32\x33\x34\x35\x36\x38\x38\x39";
        regex.punctuation = "\x21\x22\x23\x26\x27\x2c\x2d\x2e\x2f\x3a\x3b\x3f\x40\x5b\x5d";
        regex.arithmetic = "\x23\x24\x25\x28\x29\x2a\x2b\x2d\x2e\x2f\x3c\x3d\x3e";
        regex.latinextended = "\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a";
        regex.currency = "\x23\x24\x2b\x2e";

//  add the two grammars 
        grammars.push(1);
        grammars.push(2);

// if _module is set to zero, the first two grammar sets (latinbasic and digits) are activated 
// by default using the loadModule method
        loadModule(true, 1);
        loadModule(true, 2);
    }


    /**
     * note: installing means that *future* domain registrations can comply with new set. Uninstalling
     * does not affect old registrations, only future ones. Old registrations for an uninstalled grammar set
     * will still be valid.
     **/
    
    function loadModule(bool install, uint _module) 
                            alreadyInstalled(_module) 
                            checkOnlyCurated returns(bool) {
        
        if(_module == 1) {
            bytes memory lat = regex.latinbasic;
            for(uint a = 0; a < lat.length; a++) {
               set[lat[a]] = install;
            }
        }
        
        if(_module == 2) {
            bytes memory dig = module.digits;
            for(uint b = 0; b < dig.length; b++) {
                set[dig[b]] = install;
            }
        }
        
        if(_module == 3) {
            bytes memory punc = module.punctuation;
            for(uint c = 0; c < punc.length; c++) {
                set[punc[c]] = install;
            }
        }
        
        if(_module == 4) {
            bytes memory mat = module.arithmetic;
            for(uint d = 0; d < mat.length; d++ ) {
                set[mat[d]] = install;
            }
        }
        
        if(_module == 5) {
            bytes memory latex = module.latinextended;
            for(uint e = 0; e < latex.length; e++) {
                set[latex[e]] = install;
            }
        }
        
        if(_module == 6) {
            bytes memory doll = module.currency;
            for(uint f = 0; f < doll.length; f++) {
                set[doll[f]] = install;
            }
        }

        if(install = true) {
            grammars += 1;
        } else {
            grammars -= 1;
        }

        return true;
    }



    function customModule(bool _install, bytes _custom) checkOnlyCurated returns(bool) {
        regex.custom = _custom;
        for(uint i = 0; i < _custom.length; i++) {
            set[_custom[i]] = _install;
        }
        grammars += 1;
        return true;
    }


    function genesis(address _who, 
                    bytes32 _domain, 
                    bytes32 _redirect, 
                    bool _publicity) returns(bool) {
        
        bytes1 dex = _domain[0];
//  make sure that the domain is valid according to the grammar set
        if(!parseValid(_cd)) throw;
//  now check the db to ensure there is no clash
//  first consult the root contract to get the address
        address _node = Root(root).getBranch(dex);
        
        if(_node == address(0x0)) {
            _node = Root(root).setBranch(dex);
            if(!Node(_node).setInventory(_domain, _who, 10, "ipfs://", _redirect))
                throw;
            bool _added = _who.call(bytes4(sha3("add(address,bytes32,bool,string, string,string)")), 
                    msg.sender, _domain, _publicity,"","","");
            if(!_added) throw;
            return true;
        } else {
//  in this case, if the node already exists- first check that there is no clash
            if(Node(_node).getOrigin(_domain) != 0x0) 
                throw;
//  now we set inventory
            if(!Node(_node).setInventory(_domain, _who, 10, "ipfs://", _redirect))
                throw;
            bool _added = _who.call(bytes4(sha3("add(address,bytes32,bool,string, string,string)")), 
                    msg.sender, _domain, _publicity,"","","");
            if(!_added) throw;
            return true;
        }
    }
    
    function parseValid(bytes32 _domain) returns(bool) {
        valid = true;
//  get the length of the bytes32 string
        var _len = _domain.slice().len();
//  loop through the bytes and compare each one to the validity mapping
        for(uint i = 0; i < _len; i++) {
            if(set[_domain[b]] == false) {
                valid = false;
            }
            if(!valid)
                break;
        }
        return valid;
    }
    
}


contract Cluster is Owned {
    
}

library Grove {
	
	struct Index {
	// "root" is the cluster hash
		bytes32 root;
		mapping(bytes32 => Node) public nodes;
	}

	struct Node {
		bytes32 domain;
		bytes32 parent;
		uint height;
		int gravity;
		bytes32 left;
		bytes32 right;
		address who;
		bool publicity;
		mapping(bytes8 => Content) redirect;
	}

	struct Content {
		mapping(string => bytes) content;
		address eth;
		string txt;
		mapping(bytes32 => bytes) outerdomains;
	}

	function max(uint a, uint b) internal returns(uint) {
		if(a >= b) {
			return a;
		}
			return b;
	}

	function getDomainNode(Index storage index, bytes32 _domain) constant returns(bytes32) {
		return index.nodes[_domain].domain;
	}

	function getDomainNodeParent(Index storage index, bytes32 _domain) constant returns(bytes32) {
		return index[_domain].parent;
	}

	function getDomainNodeHeight(Index storage index, bytes32 _domain) constant returns(bytes32) {
		return 
	}
}

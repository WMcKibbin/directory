### Introduction

The Nebulis Directory is a blank-slate DNS built on the Ethereum blockchain. The goal of this project is to be the phonebook for the new web, compatible with a wide variety of content-addressed protocols such as the Interplanetary File System (IPFS), Storj, Swarm and MaidSafe, as well as HTTP.

### A Federated Structure

The Directory has a federated structure. The central Nebulis contract governs the creation of new clusters, which are structured rather like folders in a file system. Within a cluster, a domain can be created with accompanying A redirects. Alternatively, a subcluster can be created, to a maximum depth of 3 levels.

The traditional URL syntax follows a "specific => generic" pattern:

**scheme://subdomain.domain.tld/**

Interplanetary Addresses (IPA's) on the other hand follows a "generic => specific" pattern:

**scheme://cluster.domain/**

An IPA can have a maximum of 5 labels (3 cluster levels and 2 domain levels):

**scheme://cluster.subcluster.subcluster.domain.outerdomain/**

"Outerdomain" is the equivalent of a subdomain in a URL. It is up to protocol-specific tooling to deal with inner file paths.

The advantage is that there is no name clash with the existing DNS system.

### The Home Clusters

When Nebulis is created, there will be 8 "home clusters" on which to register Interplanetary Addresses. These will be:

|  | Ox | Cluster |  | Domain | Description |
| -- | -- | -- | -- | -- | --
| 1. | ipfs:// | home | . | example/ | a universal, generic ".com" equivalent
| 2. | ipfs:// | wallet | . |example/ | a cluster for human-readable wallet addresses
| 3. | ipfs:// | users | . | example/ | a generic user namespace and repository
| 4. | ipfs:// | wiki | . | example/ | a brand for collaborative content creation
| 5. | ipfs:// | watch | . | example/ | a cluster for video content
| 6. | ipfs:// | learn | . | example/ | for educational institutions and content
| 7. | ipfs:// | shop | . |example/ | a generic commerce cluster
| 8. | ipfs:// | public | . | example/ | for brands related to public interest

It should be noted that once one has an IPA (e.g. *"learn.wikipedia"*) you can accompany it with an unlimited number of protocol schemes-to-redirects, which is indicated by the first prefix. So you can have *"blog.leotolstoy"* can have HTTP, IPFS, Safe, Swarm or Storj records associated with it.

### The Ox Registry

The "Ox" is the name of the first label of the IPA which indicates the protocol scheme. This is an 8-byte string. When clusters are created, there are 4 verified oxes activated by default which users can register:

| | Ox | Protocol | Description
| -- | -- | -- |--
1. | ipfs:// | IPFS | The Interplanetary File System
2. | ipns:// | IPNS | The Interplanetary Name System
3. | eth:// | Ethereum | An Ethereum contract or account address
4. | http:// | HTTPS | Hypertext Transfer Protocol,, with SSL by default
5. | safe:// | SAFE Network | MaidSafe, a distributed internet
6. | storj:// | Storj | A decentralized cluod storage platform
7. | mail:// | SMTP | Simple Mail Transfer Protocol (email)
8. | shh:// | Whisper | An Ethereum communication protocol
9. | ftp:// | FTP | File Transfer Protocol (legacy)

It is possible to activate new oxes, even at the level of the user; however there is no guarantee of the authenticity of the content added to it. An Ox Registry contract is a namespace for registered oxes which will check the authenticity of content-addresses by pinging it for existence. For example, adding an IP-address to a HTTP record using the "http://" ox will cause the contract to ping an API to verify the existence of that IP-address. 

### Dust

The token on Nebulis is called "Dust", and is milled into existence at the creation of each domain. Dust holds 

### Contribute to Development

### Documentation


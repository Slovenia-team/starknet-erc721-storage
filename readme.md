# Starknet ERC721 metadata storage

The purpuse of this library is to unify/simplify the storage of the metadata for ERC721 tokens. It is ready to be used as is, by simply importing the `Storage.cairo` file to your ERC721 token and implementing the view/external caller methods. An example is given in `test\ERC721.cairo`.

It follows the OpenZeppelin ERC721 token standard for StarkNet [non-fungible tokens](https://github.com/OpenZeppelin/cairo-contracts).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Write properties](#read-properties)
  *  [setPropertyFelt](#setpropertyfelt)
  *  [setPropertyArray](#setpropertyarray)
  *  [setProperties](#setproperties)
- [Read properties](#usage)
  *  [getPropertyFelt](#getpropertyfelt)
  *  [getPropertyArray](#getpropertyarray)
  *  [getProperties](#getproperties)
- [Usage](#usage)

## Prerequisites

### Setting up the environment
A deteiled guide on how to set up the Starknet environment is accessible at [cairo lang docs](https://www.cairo-lang.org/docs/quickstart.html).

### Set up the project
Clone the repository:
``` 
git clone https://github.com/Slovenia-team/starknet-erc721-storage.git  
```

Pull the OpenZeppelin submodule:
``` 
 
```

## Write properties

### setPropertyFelt

### setPropertyArray

### setProperties


## Read properties

### getPropertyFelt

### getPropertyArray

### getProperties


## Usage

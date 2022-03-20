# Starknet ERC721 metadata storage

The purpuse of this library is to unify/simplify the storage of the metadata for ERC721 tokens. It is ready to be used as is, by simply importing the `Storage.cairo` file to your ERC721 token and implementing the view/external caller methods. An example is given in `test\ERC721.cairo`.

It follows the OpenZeppelin ERC721 token standard for StarkNet [non-fungible tokens](https://github.com/OpenZeppelin/cairo-contracts).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Write properties](#write-properties)
  *  [setPropertyFelt](#setpropertyfelt)
  *  [setPropertyArray](#setpropertyarray)
  *  [setProperties](#setproperties)
- [Read properties](#read-properties)
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
git submodule update --init --recursive
```

## Write properties

### `setPropertyFelt`

Sets a named property of type `felt` for token.

#### Parameters:
```
name: felt
tokenId: Uint256
value: felt
```

#### Returns:

None.

### `setPropertyArray`

Sets a named property of type `felt*` for token. Useful for storing longer strings.

#### Parameters:
```
name: felt
tokenId: Uint256
value_len: felt
value: felt*
```

#### Returns:

None.

### `setProperties`

Sets multiple properties of type `felt*` for token. Useful for storing multiple properties at once to reduce costs.

#### Parameters:
```
names_len: felt
names: felt*
tokenId: Uint256
offsets_len: felt
offsets: felt*
values_len: felt
values: felt*
```

#### Returns:

None.



## Read properties

### `getPropertyFelt`

Get `felt` value of named property for token.

#### Parameters:
```
name: felt
tokenId: Uint256
```

#### Returns:
```
property: felt
```


### `getPropertyArray`

Get `felt*` value of named property for token. Useful for retrieving longer strings.

#### Parameters:
```
name: felt
tokenId: Uint256
```

#### Returns:
```
property_len: felt
property: felt*
```

### `getProperties`

Get `felt*` value of multiple properties for token. Useful for retrieving multiple properties at once to reduce costs.

#### Parameters:
```
names_len: felt
names: felt*
tokenId: Uint256
```

#### Returns:
```
offsets_len: felt
offsets: felt*
properties_len: felt
properties: felt*
```

## Usage

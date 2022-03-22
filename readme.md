# Starknet ERC721 metadata storage
[![Tests and linter](https://github.com/Slovenia-team/starknet-erc721-storage/actions/workflows/python-app.yml/badge.svg)](https://github.com/Slovenia-team/starknet-erc721-storage/actions/workflows/python-app.yml)

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
- [Example Usage](#example-usage)

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

Rename ERC721 storage submodule to allow imports.
```
git mv starknet-erc721-storage starknet_erc721_storage
```

## Write properties

---
**NOTES**
1. *Property names can not exceed 31 chars.*
2. *A non-ascii character accounts for 2 characters (for example: á, é, í, ó, ú).*
---
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

## Example Usage
Let see the use of **Storage** on a practical example. Suppose we would like to store a student with parameters:
```java
name: 'John'
surname: 'Doe'
identification: 99999999
address: 'Apartment 1c 213 Derrick Street Boston, MA 02130 USA'
```
> *(Note) Let's ignore the sql noramlization rules of address for the sake of simplicity.*

We can insert all 4 parameters with one request using the `setProperties` function. In order to achive this we first need to map `strings` to `felt` since cairo only supports `felt` type.

---
**NOTES**
- Example python helper methods for string->felt (and vice versa) are accessible in `test\utils.py`. For our example we would use `str_to_felt()` for *name* and *surname* (since they can be stored as short string) and `str_to_felt_array()` for address.
---

The request looks like:
```
'name' -> 1851878757
'surname' -> 32498756660325733
'identification' -> 2137607216152422741414319187652462
'address' -> 27413455319692147
'John' -> 1248815214
'Doe' -> 4484965
'Apartment 1c 213 Derrick Street Boston, MA 02130 USA' -> [339778646234179790318151820149535281, 265461595803987861726527707067606373, 602960736248495209273730863602872370, 13848555652731713]
```
```java
names = [1851878757, 32498756660325733, 2137607216152422741414319187652462, 27413455319692147]
offsets = [1, 2, 3, 7]
values = [1248815214, 4484965, 99999999, 339778646234179790318151820149535281, 265461595803987861726527707067606373, 602960736248495209273730863602872370, 13848555652731713]

setProperties(4, names, tokenId, 4, offsets, 7, values)
```

Voila! All 4 properties are inserted. 

Now you can retrive them as:
```
getProperties(4, names, tokenId)
```

Now let's say a student gets a new grade (10) for chemistry. We can simply add it by using the `setPropertyFelt` method.
```
'chemistry' -> 1833750202349513896569
```
```
setPropertyFelt(1833750202349513896569, tokenId, 10)
```

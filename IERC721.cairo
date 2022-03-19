%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IERC721:
    func mint(
        to: felt,
        tokenId: Uint256):
    end

    func getPropertyFelt(
        name: felt,
        tokenId: Uint256) -> (property: felt):
    end

    func getPropertyArray(
        name: felt,
        tokenId: Uint256) -> (property_len: felt, property: felt*):
    end

    func getProperties(
        names_len: felt,
        names: felt*,
        tokenId: Uint256) -> (offsets_len: felt, offsets: felt*, properties_len: felt, properties: felt*):
    end

    func setPropertyFelt(
        name: felt,
        tokenId: Uint256,
        value: felt):
    end

    func setPropertyArray(
        name: felt,
        tokenId: Uint256,
        value_len: felt,
        value: felt*):
    end

    func setProperties(
        names_len: felt,
        names: felt*,
        tokenId: Uint256,
        offsets_len: felt,
        offsets: felt*,
        values_len: felt,
        values: felt*):
    end
end
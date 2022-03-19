%lang starknet
%builtins pedersen range_check ecdsa

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256


#
# Storage
#

@storage_var
func storage_properties(name: felt, token_id: Uint256) -> (property_id: felt):
end

@storage_var
func storage_property_id() -> (id: felt):
end

@storage_var
func storage_property(property_id: felt, element_id: felt) -> (element: felt):
end

@storage_var
func storage_property_len(property_id: felt) -> (len: felt):
end


#
# Constructor
#

func Storage_initializer{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}():
    
    #TODO ADD: SUPPORT interface
    #ERC165_register_interface(0x80ac58cd)
    return ()
end


#
# Getters
#

func Storage_get_property_felt{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    name: felt,
    token_id: Uint256) -> (property : felt):

    let (property_id) = storage_properties.read(name, token_id)
    let (property) = storage_property.read(property_id, 0)

    return (property)
end

func Storage_get_property_array{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    name: felt,
    token_id: Uint256) -> (property_len: felt, property: felt*):
    alloc_locals
    
    let (property_id) = storage_properties.read(name, token_id)
    let (property_len) = storage_property_len.read(property_id)

    let (local property: felt*) = alloc()
    let (property_len, property) = _read_property_as_array(property_id, property_len, property, 0)

    return (property_len=property_len, property=property)
end

func Storage_get_properties{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    names_len: felt,
    names: felt*,
    token_id: Uint256) -> (offsets_len: felt, offsets: felt*, properties_len: felt, properties: felt*):

    let offsets : felt* = alloc()
    let properties : felt* = alloc()
    let (offsets_len, offsets, properties_len, properties) = _read_multiple_properties_as_array(names_len, names, 0, offsets, 0, properties, token_id)

    return (offsets_len, offsets, properties_len, properties)
end


#
# Externals
#

func Storage_set_property_felt{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    name: felt,
    token_id: Uint256,
    value: felt):

    let (property_id) = storage_property_id.read()
    storage_properties.write(name, token_id, property_id)
    storage_property.write(property_id, 0, value)
    storage_property_len.write(property_id, 1)
    storage_property_id.write(property_id + 1)
    return ()
end


func Storage_set_property_array{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    name: felt,
    token_id: Uint256,
    value_len: felt,
    value: felt*):

    let (property_id) = storage_property_id.read()
    storage_properties.write(name, token_id, property_id)
    storage_property_len.write(property_id, value_len)
    storage_property_id.write(property_id + 1)

    _write_property_as_array(property_id, 0, value_len, 0, value_len, value)

    return ()
end


func Storage_set_properties{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    names_len: felt,
    names: felt*,
    token_id: Uint256,
    offsets_len: felt,
    offsets: felt*,
    values_len: felt,
    values: felt*):

    _write_multiple_properties_as_array(names_len, names, 0, offsets_len, offsets, values_len, values, token_id)

    return ()
end


#
# Internals
#
func _read_property_as_array{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    property_id: felt,
    res_len: felt,
    res: felt*,
    n: felt) -> (res_len: felt, res: felt*):
    alloc_locals

    if res_len == 0:
        return (res_len, res)
    end

    let (local element: felt) = storage_property.read(property_id, n)

    res[0] = element
    _read_property_as_array(property_id, res_len - 1, res + 1, n + 1)

    return (res_len, res)
end

func _read_multiple_properties_as_array{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    names_len: felt,
    names: felt*,
    offsets_len: felt,
    offsets: felt*,
    properties_len: felt,
    properties: felt*,
    token_id: Uint256) -> (offsets_len: felt, offsets: felt*, properties_len: felt, properties: felt*):
    alloc_locals

    if names_len == 0:
        return (offsets_len, offsets, properties_len, properties)
    end

    let (property_id) = storage_properties.read(names[offsets_len], token_id)
    let (property_len) = storage_property_len.read(property_id)
    _read_property_as_array(property_id, property_len, properties, 0)
    assert offsets[0] = properties_len + property_len

    let (new_offsets_len, new_offsets, new_properties_len, new_properties) = _read_multiple_properties_as_array(
        names_len - 1, 
        names, 
        offsets_len + 1, 
        offsets + 1, 
        properties_len + property_len, 
        properties + property_len, 
        token_id)

    return (new_offsets_len, offsets, new_properties_len, properties)
end


func _write_property_as_array{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    property_id: felt,
    offset_from: felt,
    offset_to: felt,
    n: felt,
    value_len: felt,
    value: felt*):

    if offset_from + n == offset_to:
        return ()
    end

    storage_property.write(property_id, n, value[offset_from + n])
    _write_property_as_array(property_id, offset_from, offset_to, n + 1, value_len, value)

    return ()
end

func _write_multiple_properties_as_array{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr}(
    names_len: felt,
    names: felt*,
    n: felt,
    offsets_len: felt,
    offsets: felt*,
    values_len: felt,
    values: felt*,
    token_id: Uint256):
    alloc_locals

    if n == offsets_len:
        return ()
    end

    let (property_id) = storage_property_id.read()
    storage_properties.write(names[n], token_id, property_id)
    storage_property_id.write(property_id + 1)

    if n == 0:
        storage_property_len.write(property_id, offsets[n])
        _write_property_as_array(property_id, 0, offsets[n], 0, offsets[n], values)
    end

    if n != 0:
        storage_property_len.write(property_id, offsets[n] - offsets[n - 1])
        _write_property_as_array(property_id, offsets[n - 1], offsets[n], 0, offsets[n] - offsets[n - 1], values)
    end

    _write_multiple_properties_as_array(names_len, names, n + 1, offsets_len, offsets, values_len, values, token_id)

    return ()
end
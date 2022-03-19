from functools import reduce
import os
from utils import *

import pytest
from starkware.crypto.signature.signature import private_to_stark_key
from starkware.starknet.testing.contract import StarknetContract
from starkware.starknet.testing.starknet import Starknet

STARK_KEY = private_to_stark_key(1234567)

CONTRACT_FILE = os.path.join(os.path.dirname(__file__), 'ERC721.cairo')

async def deploy() -> (StarknetContract):
    starknet = await Starknet.empty()
    contract = await starknet.deploy(
        source=CONTRACT_FILE,
        constructor_calldata=[str_to_felt("User Token"), str_to_felt("UT"), STARK_KEY],
        cairo_path=['cairo-contracts'])

    return contract


@pytest.mark.asyncio
async def test_getters():
    (contract) = await deploy()

    await contract.setPropertyFelt(name=str_to_felt('ime'), tokenId=uint256(1), value=str_to_felt('Janez')).invoke(caller_address=STARK_KEY)
    await contract.setPropertyFelt(name=str_to_felt('priimek'), tokenId=uint256(1), value=str_to_felt('Kranjski')).invoke(caller_address=STARK_KEY)

    exec_info = await contract.getPropertyFelt(name=str_to_felt('ime'), tokenId=uint256(1)).call()
    #print(felt_to_str(exec_info.result[0]))
    assert felt_to_str(exec_info.result[0]) == "Janez"

    exec_info = await contract.getPropertyArray(name=str_to_felt('ime'), tokenId=uint256(1)).call()
    #print(felt_to_str(exec_info.result[0][0]))
    assert felt_to_str(exec_info.result[0][0]) == "Janez"

    exec_info = await contract.getProperties(names=[str_to_felt('ime'), str_to_felt('priimek')], tokenId=uint256(1)).call()
    #for prop in exec_info.result[1]:
    #    print(felt_to_str(prop), end=" ")
    assert felt_to_str(exec_info.result[1][0]) == "Janez"
    assert felt_to_str(exec_info.result[1][1]) == "Kranjski"


@pytest.mark.asyncio
async def test_set_property_array():
    (contract) = await deploy()

    await contract.setPropertyArray(name=str_to_felt('opis'), tokenId=uint256(1), value=str_to_felt_array('1 Janez je šel po Ježa in nato se je vrnil v svojo Jazbino kjer je zaspal trdno kot Trnjuljčica.')).invoke(caller_address=STARK_KEY)

    exec_info = await contract.getPropertyArray(name=str_to_felt('ime'), tokenId=uint256(1)).call()
    res = reduce(lambda x, y: x + felt_to_str(y), exec_info.result[0], '')

    assert res == '1 Janez je šel po Ježa in nato se je vrnil v svojo Jazbino kjer je zaspal trdno kot Trnjuljčica.'


@pytest.mark.asyncio
async def test_set_properties():
    (contract) = await deploy()

    names = [str_to_felt('ime'), str_to_felt('opis')]
    properties = ['Janez', '1 Janez je šel po Ježa in nato se je vrnil v svojo Jazbino kjer je zaspal trdno kot Trnjuljčica.']
    offsets = []
    values = []
    for property in properties:
        values = values + str_to_felt_array(property)
        offsets.append(len(values))
    
    await contract.setProperties(names=names, tokenId=uint256(1), offsets=offsets, values=values).invoke(caller_address=STARK_KEY)

    exec_info = await contract.getProperties(names=[str_to_felt('ime'), str_to_felt('opis')], tokenId=uint256(1)).call()

    properties = []
    offset_from = 0
    for offset in exec_info.result[0]:
        properties.append(reduce(lambda x, y: x + felt_to_str(y), exec_info.result[1][offset_from:offset], ''))
        offset_from = offset

    assert properties[0] == 'Janez'
    assert properties[1] == '1 Janez je šel po Ježa in nato se je vrnil v svojo Jazbino kjer je zaspal trdno kot Trnjuljčica.'

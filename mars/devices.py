#!/usr/bin/env python

from mars.core import Device
from mars.environment import *


def get_device_from_collection(device_name, device_collection):
    if isinstance(device_collection, list):
        for device in device_collection:
            if device.get_name() == device_name:
                return device
    return device_collection


def update_device_in_collection(device, device_collection):
    if isinstance(device_collection, list):
        for device_id, device_to_update in enumerate(device_collection):
            if device_to_update.get_name() == device.get_name():
                device_collection[device_id] = device
        return device_collection
    return [device]


class DeviceFactory(object):
    def __init__(self,logger):
        self.logger = logger

    def create(self, device_name, device_parameters):

        if device_name == 'DummyDevice': return DummyDevice()
        if device_name == 'CommunicationSystem': return CommunicationSystem()

        self.logger.log_system_info('ERROR',' No valid DEVICE.name: ' + device_name )
        return False


class DummyDevice(Device):
    def __init__(self):
        super().__init__()
        self._name = 'DummyDevice'

    def read_from_environment(self, logger, environment):
        pass

    def write_to_environment(self, logger, environment):
        pass


class CommunicationSystem(Device):
    def __init__(self):
        super().__init__()
        self._name = 'CommunicationSystem'

    def read_from_environment(self, logger, environment):
        communication_network = \
            get_environment_object_from_collection('CommunicationNetwork', environment)
        self._ingoing_data = communication_network.receive(self._agent_id)

    def write_to_environment(self, logger, environment):
        communication_network = \
            get_environment_object_from_collection('CommunicationNetwork', environment)

        communication_network.send(self._agent_id, self._outgoing_data)
        return update_environment_object_in_collection(communication_network,environment)
#! /usr/bin/env python

import unittest

from core import Logger
from devices import *


class DeviceFactoryTestCase(unittest.TestCase):

    def test_DeviceFactoryCreateSuccess(self):
        device_factory = DeviceFactory(Logger(False))
        device = device_factory.create('DummyDevice',[])

        self.assertEqual(device.get_name(),'DummyDevice')

    def test_DeviceFactoryCreateWithParametersSuccess(self):
        device_factory = DeviceFactory(Logger(False))
        device = device_factory.create('CommunicationSystem',['node_id_01'])

        self.assertEqual(device.get_name(),'CommunicationSystem')

    def test_TaskFactoryInvalidNameReturnFalse(self):
        device_factory = DeviceFactory(Logger(False))

        self.assertFalse(device_factory.create('InvalidNamedDevice',[]))


class CommunicationSystemTestCase(unittest.TestCase):

    def test_BuildDeviceSuccess(self):
        device = CommunicationSystem()
        device.set_agent_id([1])

        self.assertEqual(device.get_name(),'CommunicationSystem')

    def test_RunDeviceSuccess(self):
        communication_network = CommunicationNetwork([ ['A', 'B'] ])

        com_sys_A = CommunicationSystem()
        com_sys_A.set_agent_id('A')
        com_sys_A.set_outgoing_data('Hello, I am Alice!')
        communication_network = com_sys_A.write_to_environment(Logger(False), communication_network)

        com_sys_B = CommunicationSystem()
        com_sys_B.set_agent_id('B')
        com_sys_B.set_outgoing_data('Hello, I am Bob!')
        communication_network = com_sys_B.write_to_environment(Logger(False), communication_network)

        com_sys_A.read_from_environment(Logger(False), communication_network)
        com_sys_B.read_from_environment(Logger(False), communication_network)

        self.assertEqual(com_sys_A.get_ingoing_data(), [ ['B', 'Hello, I am Bob!'] ])
        self.assertEqual(com_sys_B.get_ingoing_data(), [ ['A', 'Hello, I am Alice!'] ])


if __name__ == '__main__':
    unittest.main()

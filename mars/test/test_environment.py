#! /usr/bin/env python

import unittest

from core import Logger
from environment import *


class EnvironmentFactoryTestCase(unittest.TestCase):

    def test_EnvironmentFactoryCreateSuccess(self):
        env_factory = EnvironmentFactory(Logger(False))
        env_object = env_factory.create('DummyEnvironmentObject',[])

        self.assertEqual(env_object.get_name(),'DummyEnvironmentObject')

    def test_EnvironmentFactoryCreateWithParametersSuccess(self):
        env_factory = EnvironmentFactory(Logger(False))
        env_object = env_factory.create('CommunicationNetwork',[])

        self.assertEqual(env_object.get_name(),'CommunicationNetwork')

    def test_EnvironmentFactoryInvalidNameReturnFalse(self):
        env_factory = EnvironmentFactory(Logger(False))

        self.assertFalse(env_factory.create('InvalidNameEnvironmentObject',[]))


class QueueTestCase(unittest.TestCase):

    def test_QueuePushPopSuccess(self):
        queue = Queue()
        queue.push(['A key','A value'])

        self.assertEqual(queue.pop(),['A key', 'A value'])

    def test_QueueIsEmptySuccess(self):
        queue = Queue()
        queue.push(['A key','A value'])
        queue.pop()

        self.assertTrue(queue.isEmpty())

    def test_QueueSizeSuccess(self):
        queue = Queue()
        queue.push(['A key','A value'])
        queue.push(['A second key', 'A second value'])

        self.assertEqual(queue.size(),2)


class GraphTestCase(unittest.TestCase):

    def test_GraphAddNodeSuccess(self):
        graph = Graph()
        graph.add_node('A')
        graph.add_node('B')
        graph.add_node('C')

        self.assertEqual(graph.get_node_collection(),['A', 'B', 'C'])

    def test_GraphAddLinkSuccess(self):
        graph = Graph()
        graph.add_link('A', 'B')
        graph.add_link('A', 'C')

        self.assertEqual(graph.get_node_linked_collection('A'),{'B', 'C'})

    def test_GraphRemoveNodeSuccess(self):
        graph = Graph()
        graph.add_node('A')
        graph.add_node('B')
        graph.add_node('C')
        graph.add_link('A', 'B')
        graph.add_link('A', 'C')

        graph.remove_node('B')

        self.assertEqual(graph.get_node_collection(), ['A', 'C'])
        self.assertEqual(graph.get_node_linked_collection('A'), {'C'})
        self.assertEqual(graph.get_node_linked_collection('C'), {'A'})

class CommunicationNetworkTestCase(unittest.TestCase):

    def test_CompleteK2GraphCommunicationSuccess(self):
        communication_network = CommunicationNetwork([ ['A','B'] ])

        communication_network.send('A', 'hello world, I am Alice!')
        communication_network.send('B', 'hello world, I am Bob!')

        self.assertEqual(communication_network.receive('A'),[ ['B','hello world, I am Bob!'] ])
        self.assertEqual(communication_network.receive('B'),[ ['A','hello world, I am Alice!'] ])

    def test_CompleteK2GraphCommunicationOnlyOneNode(self):
        communication_network = CommunicationNetwork([['A', 'B']])

        communication_network.send('A', 'hello world, I am Alice!')

        self.assertEqual(communication_network.receive('A'), [ ])
        self.assertEqual(communication_network.receive('B'), [ ['A', 'hello world, I am Alice!'] ])


    def test_Line3NodesGraphCommunicationSuccess(self):

        communication_network = CommunicationNetwork([ ['A','B'], ['B','C']  ])

        communication_network.send('A', 'hello world, I am Alice!')
        communication_network.send('B', 'hello world, I am Bob!')
        communication_network.send('C', 'hello world, I am Charlie!')

        self.assertEqual(communication_network.receive('A'),[ ['B', 'hello world, I am Bob!'] ])

        self.assertEqual(communication_network.receive('B'),[ ['A', 'hello world, I am Alice!'],
                                                              ['C', 'hello world, I am Charlie!'] ])

        self.assertEqual(communication_network.receive('C'), [['B', 'hello world, I am Bob!']])


if __name__ == '__main__':
    unittest.main()

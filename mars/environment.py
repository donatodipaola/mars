#!/usr/bin/env python

from collections import defaultdict
from core import EnvironmentObject


def get_environment_object_from_collection(object_name, object_collection):
    if isinstance(object_collection, list):
        for object in object_collection:
            if object.get_name() == object_name:
                return object
    return object_collection


def update_environment_object_in_collection(object, object_collection):
    if isinstance(object_collection, list):
        for object_id, object_to_update in enumerate(object_collection):
            if object_to_update.get_name() == object.get_name():
                object_collection[object_id] = object
        return object_collection
    return [object]


class EnvironmentFactory(object):
    def __init__(self,logger):
        self.logger = logger

    def create(self, object_name, object_parameters):

        if object_name == 'DummyEnvironmentObject': return DummyEnvironmentObject()
        if object_name == 'CommunicationNetwork': return CommunicationNetwork(object_parameters)

        self.logger.log_system_info('ERROR',' No valid EnvironmentObject.name: ' + object_name )
        return False


class DummyEnvironmentObject(EnvironmentObject):
    def __init__(self):
        super().__init__()
        self._name = 'DummyEnvironmentObject'


class CommunicationNetwork(EnvironmentObject):
    def __init__(self, parameters):
        super().__init__()
        self._name = 'CommunicationNetwork'

        self.__communication_queue_collection = dict()
        self.__communication_graph = Graph()

        self.__build_infrastructure(parameters)

    def __build_infrastructure(self, link_collection):
        for link in link_collection:
            self.__communication_graph.add_link(link[0],link[1])

        for node_id in self.__communication_graph.get_node_collection():
            self.__communication_queue_collection[str(node_id)] = Queue()

    def send(self, node_id, message):
        for receiver_node_id in self.__communication_graph.get_node_linked_collection(str(node_id)):
            self.__communication_queue_collection[receiver_node_id].push([node_id, message])

    def receive(self, node_id):
        receiver_node_queue = self.__communication_queue_collection[str(node_id)]

        message_list = list()
        for i in range(0, receiver_node_queue.size()):
            message_list.append(receiver_node_queue.pop())
        return message_list


class Queue:
    def __init__(self):
        self.__item_collection = list()

    def isEmpty(self):
        return not self.__item_collection

    def push(self, item):
        self.__item_collection.insert(0,item)

    def pop(self):
        return self.__item_collection.pop()

    def size(self):
        return len(self.__item_collection)


class Graph(object):

    def __init__(self):
        self._graph = defaultdict(set)

    def add_node(self, node):
        self._graph[node] = set()

    def add_link(self, node1, node2):

        self._graph[node1].add(node2)
        self._graph[node2].add(node1)

    def get_node_collection(self):
        return list(dict(self._graph.items()).keys())

    def get_node_linked_collection(self, node):
        return self._graph[node]

    def remove_node(self, node):
        for n, links in self._graph.items():
            try:
                links.remove(node)
            except KeyError:
                pass
        try:
            del self._graph[node]
        except KeyError:
            pass

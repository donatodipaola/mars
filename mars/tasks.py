#!/usr/bin/env python

from core import Task
from devices import *


class TaskFactory(object):
    def __init__(self,logger):
        self.logger = logger

    def create(self, task_name, task_parameters):

        if task_name == 'DummyTask': return DummyTask()
        if task_name == 'Counter': return Counter(task_parameters)
        if task_name == 'Ping': return Ping(task_parameters)
        if task_name == 'AverageConsensus': return AverageConsensus(task_parameters)

        self.logger.log_system_info('ERROR',' No valid TASK.name: ' + task_name )
        return False


class DummyTask(Task):

    def __init__(self):
        super().__init__()
        self._name = 'DummyTask'

    def _check_start_condition(self):
        return True

    def _check_stop_condition(self):
        self._state = Task.State.COMPLETED_OK

    def _execute(self, logger, device_collection = list()):
        self._state = Task.State.RUNNING
        return device_collection


class Counter(Task):

    def __init__(self, parameter_collection):
        super().__init__()
        self._name = 'Counter'

        self.__variable = parameter_collection[0]
        self.__final_value = parameter_collection[1]

    def _check_start_condition(self):
        return True

    def _check_stop_condition(self):
        if self.__variable == self.__final_value:
            self._state = Task.State.COMPLETED_OK

    def _execute(self, logger, device_collection = list()):
        logger.log_variable_iteration(self._name, self.__variable)
        self._state = Task.State.RUNNING

        self.__variable += 1
        return device_collection


class Ping(Task):

    def __init__(self, parameter):
        super().__init__()
        self._name = 'Ping'

        self.__variable = parameter

    def get_variable(self):
        return self.__variable

    def _check_start_condition(self):
        return True

    def _check_stop_condition(self):
        pass

    def _is_ping(self, received_message_collection):
        for message in received_message_collection:
            return message[1] == 'ping'

    def _is_pong(self, received_message_collection):
        for message in received_message_collection:
            return message[1] == 'pong'

    def _execute(self, logger, device_collection = list()):
        self._state = Task.State.RUNNING

        com_device = get_device_from_collection('CommunicationSystem', device_collection)

        ingoing_data = com_device.get_ingoing_data()

        if(self._is_ping(ingoing_data)):
            self.__variable = 'pong'
        if(self._is_pong(ingoing_data)):
            self.__variable = 'ping'

        com_device.set_outgoing_data(self.__variable)
        logger.log_variable_iteration(self._name, self.__variable)

        return update_device_in_collection(com_device, device_collection)


class AverageConsensus(Task):

    def __init__(self, parameter_collection):
        super().__init__()
        self._name = 'AverageConsensus'

        self.__variable = parameter_collection[0]
        self.__weight = parameter_collection[1]


    def get_variable(self):
        return self.__variable

    def _check_start_condition(self):
        return True

    def _check_stop_condition(self):
        pass

    def _sum_neighbor_values(self, received_message_collection):
        sum_of_values = 0.0
        for message in received_message_collection:
            if message[1]:
                sum_of_values += self.__weight * float(message[1])
        return sum_of_values

    def _execute(self, logger, device_collection=list()):
        logger.log_variable_iteration(self._name, self.__variable)
        self._state = Task.State.RUNNING

        com_device = get_device_from_collection('CommunicationSystem', device_collection)

        ingoing_data = com_device.get_ingoing_data()

        if ingoing_data:
            variable_update = self.__weight * self.__variable
            neighbors_update = self._sum_neighbor_values(ingoing_data)

            self.__variable = variable_update + neighbors_update

            com_device.set_outgoing_data(self.__variable)
            return update_device_in_collection(com_device, device_collection)

        com_device.set_outgoing_data(self.__variable)
        return update_device_in_collection(com_device, device_collection)



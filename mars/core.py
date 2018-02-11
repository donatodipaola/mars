#!/usr/bin/env python

from enum import Enum
from abc import ABC, abstractmethod
import logging
import sys
import datetime

class Device(ABC):

    def __init__(self):
        self._name = 'Device'
        self._agent_id = None
        self._outgoing_data = None
        self._ingoing_data = list()

    def set_agent_id(self, agent_id):
        self._agent_id = agent_id

    def get_name(self):
        return self._name

    def set_outgoing_data(self, outgoing_data):
        self._outgoing_data = outgoing_data

    def get_ingoing_data(self):
        return self._ingoing_data

    @abstractmethod
    def read_from_environment(self, logger, environment):
        pass

    @abstractmethod
    def write_to_environment(self, logger, environment):
        pass


class Task(ABC):

    class State(Enum):
        UNKNOWN = 0
        READY = 1
        RUNNING = 2
        COMPLETED_OK = 3
        COMPLETED_KO = 4

    def __init__(self):
        self._name = 'Task'
        self._agent_id = None
        self._state = Task.State.READY

    def set_agent_id(self, agent_id):
        self._agent_id = agent_id

    def get_name(self):
        return self._name

    def get_state(self):
        return self._state

    def run_iteration(self, logger, device_collection=list()):
        logger.log_task_iteration(self._name, self._state)

        iteration_device_collection = list()
        if self.__can_run() and self._check_start_condition():
            iteration_device_collection = self._execute(logger, device_collection)

        self._check_stop_condition()

        return iteration_device_collection

    def __can_run(self):
        return self._state == Task.State.READY or \
               self._state == Task.State.RUNNING

    @abstractmethod
    def _check_start_condition(self):
        pass

    @abstractmethod
    def _check_stop_condition(self):
        pass

    @abstractmethod
    def _execute(self, logger, device_collection=list()):
        pass


class Agent(object):

    class State(Enum):
        UNKNOWN = 0
        STANDBY = 1
        RUNNING = 2

    def __init__(self, identifier, task, device_collection=list()):
        self.__id = identifier
        self.__state = Agent.State.STANDBY
        self.__clock = 0

        self.__task = self._register_task(task)

        self.__device_collection = \
            self._register_device_collection(device_collection)

    def _register_device_collection(self, device_collection):
        for device in device_collection:
            device.set_agent_id(self.__id)
        return device_collection

    def _register_task(self, task):
        task.set_agent_id(self.__id)
        return task

    def get_id(self):
        return self.__id

    def get_state(self):
        return self.__state

    def get_clock(self):
        return self.__clock

    def run_sense_from_environment(self, logger, environment = list()):
        for device in self.__device_collection:
            device.read_from_environment(logger, environment)

    def run_task(self, logger):
        logger.log_agent_iteration(self.__id, self.__clock, self.__state)

        self.__device_collection = \
            self.__task.run_iteration(logger, self.__device_collection)

        self.__state = Agent.State.RUNNING
        self.__clock += 1

    def run_act_to_environment(self, logger, environment = list()):
        updated_environment = list()

        for device in self.__device_collection:
            updated_environment = device.write_to_environment(logger, environment)

        return updated_environment


class EnvironmentObject(object):

    def __init__(self):
        self._name = 'EnvironmentObject'

    def get_name(self):
        return self._name


class Simulation(object):
    def __init__(self, time_horizon, agent_collection = list(), environment = list()):
        self.__clock = 0
        self.__time_horizon = time_horizon
        self.__agent_collection = agent_collection
        self.__environment = environment

    def get_clock(self):
        return self.__clock

    def run(self, logger):
        logger.log_system_info('SIMULATION', 'Started ...')

        if not self.__agent_collection:
            return False

        while self.__clock != self.__time_horizon + 1:
            self.__run_iteration(logger)
            self.__clock += 1

        logger.log_system_info('SIMULATION', 'Completed')
        return True

    def __run_iteration(self, logger):
        logger.log_simulation_iteration(self.__clock)

        for agent in self.__agent_collection:
            agent.run_sense_from_environment(logger, self.__environment)

        for agent in self.__agent_collection:
            agent.run_task(logger)
            logger.log_iteration()

        for agent in self.__agent_collection:
            self.__environment = agent.run_act_to_environment(logger, self.__environment)




class Logger(object):
    def __init__(self, is_active=True, to_file=False):
        self.__active = is_active
        self.__to_file = to_file

        self.__simulation_clock = 0

        self.__agent_id = 0
        self.__agent_clock = 0
        self.__agent_state = ''

        self.__task_name = 0
        self.__task_state = ''

        self.__variable_name = 0
        self.__variable_value = ''


        logFormatter = logging.Formatter('%(asctime)s %(message)s')
        self.rootLogger = logging.getLogger()
        self.rootLogger.setLevel(logging.DEBUG)

        consoleHandler = logging.StreamHandler(sys.stdout)
        consoleHandler.setFormatter(logFormatter)
        self.rootLogger.addHandler(consoleHandler)

        if self.__to_file:
            filename = 'mars_log_' + datetime.datetime.now().isoformat()
            fileHandler = logging.FileHandler('{0}/{1}.log'.format('.', filename))
            fileHandler.setFormatter(logFormatter)
            self.rootLogger.addHandler(fileHandler)

    def log_system_info(self, tag, message):
        if self.__active:
            self.rootLogger.info('[' + tag + '] '  + message)

    def log_iteration(self):
        log_message = self.__build_log()
        if log_message and self.__active:
            self.rootLogger.info(log_message)

        self.__agent_id = 0
        self.__task_name =0
        self.__variable_name = 0

    def log_simulation_iteration(self, simulation_clock):
        self.__simulation_clock = simulation_clock

    def log_agent_iteration(self, agent_id, agent_clock, agent_state):
        self.__agent_id = agent_id
        self.__agent_clock = agent_clock
        self.__agent_state = agent_state

    def log_task_iteration(self, task_name, task_state):
        self.__task_name = task_name
        self.__task_state = task_state

    def log_variable_iteration(self, variable_name, variable_value):
        self.__variable_name = variable_name
        self.__variable_value = variable_value

    def __build_log(self):
        if self.__agent_id == 0 and self.__task_name == 0:
            return ''

        message = '[SIMULATION] (clock:' + str(self.__simulation_clock) + ') | ' +\
                  '[AGENT] (id:' + str(self.__agent_id) + ') ' +\
                  '(clock:' + str(self.__agent_clock) + ') ' + \
                  '(state:' + str(self.__agent_state)[6:] + ') | ' + \
                  '[TASK] (name:' + str(self.__task_name) + ') ' +\
                  '(state:' + str(self.__task_state)[6:] + ')'

        if self.__variable_name != 0:
            message += ' [VARIABLE] (' + str(self.__variable_name) + ':' + str(self.__variable_value) + ')'

        return message

import yaml
from pathlib import Path

from core import *
from tasks import *
from devices import *


class Builder(object):
    def __init__(self, logger):
        self.__logger = logger
        self.__log_tag = 'SETUP'

    def build_from_file(self, file_path):
        self.__logger.log_system_info(self.__log_tag, 'MARS building started ...')

        simulation_configuration = \
            self.__read_configuration_from_file(file_path)

        if(not simulation_configuration):
            self.__logger.log_system_info(self.__log_tag, 'MARS building aborted!')
            return []

        simulation = self.__build_simulation(simulation_configuration['simulation'])

        self.__logger.log_system_info(self.__log_tag, 'MARS building completed')

        return simulation

    def __read_configuration_from_file(self, file_path):
        if not Path(file_path).is_file():
            self.__logger.log_system_info('ERROR', 'Invalid configuration file path')
            return []
        self.__logger.log_system_info(self.__log_tag, 'Configuration loading from file ...')

        with open(file_path, 'r') as file:
            simulation_configuration_data = yaml.load(file)
        return simulation_configuration_data

    def __build_simulation(self, simulation_configuration):
        self.__logger.log_system_info(self.__log_tag, 'SIMULATION building started ...')

        simulation_time_horizon = \
            simulation_configuration['simulation_time_horizon']
        self.__logger.log_system_info(self.__log_tag, 'Set simulation horizon to: ' + str(simulation_time_horizon))

        simulation_environment = list()
        if('environment' in simulation_configuration):
            simulation_environment = \
                self.__build_environment(simulation_configuration['environment'])

        simulation_agent_collection = \
            self.__build_agent_collection(simulation_configuration['agents'])

        simulation = Simulation(simulation_time_horizon, simulation_agent_collection, simulation_environment)
        self.__logger.log_system_info(self.__log_tag, 'SIMULATION building completed')

        return simulation

    def __build_environment(self, environment_configuration):
        self.__logger.log_system_info(self.__log_tag, 'ENVIRONMENT building started ...')
        environment = list()

        for environment_object_configuration in environment_configuration['environment_object_collection']:
            environment_object_factory = EnvironmentFactory(self.__logger)

            environment_object_name = \
                environment_object_configuration['environment_object']['name']
            environment_object_parameters = \
                environment_object_configuration['environment_object']['parameters']
            environment_object = environment_object_factory.create(environment_object_name,
                                                                   environment_object_parameters)

            environment.append(environment_object)

        self.__logger.log_system_info(self.__log_tag, 'ENVIRONMENT building completed')
        return environment


    def __build_agent_collection(self, agents_configuration):
        self.__logger.log_system_info(self.__log_tag, 'AGENT Collection building started ...')
        agent_collection = list()

        task_name = agents_configuration['task']


        for agent_configuration in agents_configuration['agent_collection']:
            task_factory = TaskFactory(self.__logger)

            task_parameters = list()
            if('task_parameters' in agent_configuration['agent']):
                task_parameters = agent_configuration['agent']['task_parameters']
            task = task_factory.create(str(task_name), task_parameters)

            device_collection = list()
            if ('device_collection' in agent_configuration['agent']):
                device_collection_configuration = agent_configuration['agent']['device_collection']

                device_parameters = list()
                for device in device_collection_configuration:
                    if ('device_parameters' in device['device']):
                        device_parameters = device['device']['parameters']
                    device_collection.append(DeviceFactory(self.__logger).create(device['device']['name'],
                                                                                 device_parameters))

            agent_identifier = agent_configuration['agent']['identifier']
            agent = Agent(agent_identifier, task,device_collection)

            self.__logger.log_system_info(self.__log_tag, 'Created Agent ' + str(agent.get_id()))
            self.__logger.log_system_info(self.__log_tag, 'Added Task ' + task.get_name() + ' to Agent ' + str(agent.get_id()))

            agent_collection.append(agent)

        self.__logger.log_system_info(self.__log_tag, 'AGENT Collection building completed')
        return agent_collection

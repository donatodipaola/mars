#! /usr/bin/env python

import unittest

import io
import os

from mars.builder import *


def create_configuration_file():

    data = {'simulation':
                {'simulation_time_horizon': 100,
                 'environment' :
                     {'environment_object_collection':
                            [{ 'environment_object' :
                            { 'name' : 'CommunicationNetwork',
                              'parameters' : [
                                            ['A', 'B'],
                                            ['B', 'C']]
                            }}]
                      },
                 'agents':
                     {'task' : 'Counter',
                      'agent_collection':
                          [{'agent': {'identifier': 'A',
                                      'device_collection':
                                          [{'device' : {'name': 'CommunicationSystem',
                                                        'parameters' : 'A'}}],
                                      'task_parameters': [0, 1]}},
                           {'agent': {'identifier': 'B',
                                      'device_collection':
                                          [{'device': {'name': 'CommunicationSystem',
                                                       'parameters': 'B'}}],
                                      'task_parameters': [0, 2]}}
                          ]
                     }
                 }
            }

    with io.open('config_test.yaml', 'w', encoding='utf8') as outfile:
        yaml.dump(data, outfile, default_flow_style=False, allow_unicode=True)

def delete_configuration_file():
    os.remove('config_test.yaml')

class BuilderTestCase(unittest.TestCase):

    def test_BuilderCreateMarsFromFileSuccess(self):
        builder = Builder(Logger(False))
        create_configuration_file()

        simulation = builder.build_from_file("config_test.yaml")

        self.assertEqual(simulation.get_clock(),0)
        delete_configuration_file()


if __name__ == '__main__':
    unittest.main()

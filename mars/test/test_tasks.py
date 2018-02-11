#! /usr/bin/env python

import unittest

from core import Logger
from tasks import *
from devices import *


class TaskFactoryTestCase(unittest.TestCase):

    def test_TaskFactoryCreateSuccess(self):
        task_factory = TaskFactory(Logger(False))
        task = task_factory.create('DummyTask',[])

        self.assertEqual(task.get_name(),'DummyTask')

    def test_TaskFactoryCreateWithParametersSuccess(self):
        task_factory = TaskFactory(Logger(False))
        task = task_factory.create('Counter',[0, 1])

        self.assertEqual(task.get_name(),'Counter')

    def test_TaskFactoryInvalidNameReturnFalse(self):
        task_factory = TaskFactory(Logger(False))

        self.assertFalse(task_factory.create('InvalidNamedTask',[]))


class DummyTaskTestCase(unittest.TestCase):

    def test_BuildTaskSuccess(self):
        task = DummyTask()

        self.assertEqual(task.get_name(),'DummyTask')
        self.assertEqual(task.get_state(), Task.State.READY)

    def test_RunTaskSuccess(self):
        task = DummyTask()
        task.run_iteration(Logger(False))

        self.assertEqual(task.get_state(), Task.State.COMPLETED_OK)


class CounterTestCase(unittest.TestCase):

    def test_BuildTaskSuccess(self):
        task = Counter([0,10])

        self.assertEqual(task.get_name(),'Counter')
        self.assertEqual(task.get_state(), Task.State.READY)

    def test_RunTaskSuccess(self):
        task = Counter([0,10])
        task.run_iteration(Logger(False))

        self.assertEqual(task.get_state(), Task.State.RUNNING)

    def test_CompletedTaskSuccess(self):
        task = Counter([0,10])
        while task.get_state() != Task.State.COMPLETED_OK:
            task.run_iteration(Logger(False))

        self.assertEqual(task.get_state(), Task.State.COMPLETED_OK)


class PingTestCase(unittest.TestCase):

  def test_BuildTaskSuccess(self):
      task = Ping('ping')

      self.assertEqual(task.get_name(),'Ping')
      self.assertEqual(task.get_state(), Task.State.READY)

  def test_RunTaskSuccess(self):
      communication_network = CommunicationNetwork([['A', 'B']])

      com_device_A = CommunicationSystem()
      com_device_A.set_agent_id('A')
      device_collection_A = list()
      device_collection_A.append(com_device_A)
      task_A = Ping('ping')

      com_device_B = CommunicationSystem()
      com_device_B.set_agent_id('B')
      device_collection_B = list()
      device_collection_B.append(com_device_B)
      task_B = Ping('pong')


      device_collection_A[0].read_from_environment(Logger(False), communication_network)
      device_collection_B[0].read_from_environment(Logger(False), communication_network)

      device_collection_A = task_A.run_iteration(Logger(False), device_collection_A)
      device_collection_B = task_B.run_iteration(Logger(False),device_collection_B)

      communication_network = device_collection_A[0].write_to_environment(Logger(False), communication_network)
      communication_network = device_collection_B[0].write_to_environment(Logger(False), communication_network)

      self.assertEqual(task_A.get_variable(),'ping')
      self.assertEqual(task_B.get_variable(),'pong')


      device_collection_A[0].read_from_environment(Logger(False), communication_network)
      device_collection_B[0].read_from_environment(Logger(False), communication_network)

      device_collection_A = task_A.run_iteration(Logger(False), device_collection_A)
      device_collection_B = task_B.run_iteration(Logger(False), device_collection_B)

      communication_network = device_collection_A[0].write_to_environment(Logger(False), communication_network)
      communication_network = device_collection_B[0].write_to_environment(Logger(False), communication_network)

      self.assertEqual(task_A.get_variable(), 'ping')
      self.assertEqual(task_B.get_variable(), 'pong')


      device_collection_A[0].read_from_environment(Logger(False), communication_network)
      device_collection_B[0].read_from_environment(Logger(False), communication_network)

      device_collection_A = task_A.run_iteration(Logger(False), device_collection_A)
      device_collection_B = task_B.run_iteration(Logger(False), device_collection_B)

      communication_network = device_collection_A[0].write_to_environment(Logger(False), communication_network)
      communication_network = device_collection_B[0].write_to_environment(Logger(False), communication_network)

      self.assertEqual(task_A.get_variable(), 'ping')
      self.assertEqual(task_B.get_variable(), 'pong')


      device_collection_A[0].read_from_environment(Logger(False), communication_network)
      device_collection_B[0].read_from_environment(Logger(False), communication_network)

      device_collection_A = task_A.run_iteration(Logger(False), device_collection_A)
      device_collection_B = task_B.run_iteration(Logger(False), device_collection_B)

      communication_network = device_collection_A[0].write_to_environment(Logger(False), communication_network)
      device_collection_B[0].write_to_environment(Logger(False), communication_network)

      self.assertEqual(task_A.get_variable(), 'ping')
      self.assertEqual(task_B.get_variable(), 'pong')


class AverageConsensusTestCase(unittest.TestCase):

  def test_BuildTaskSuccess(self):
      task = AverageConsensus([0.77, 0.0])

      self.assertEqual(task.get_name(),'AverageConsensus')
      self.assertEqual(task.get_state(), Task.State.READY)

  def test_RunTaskSuccess(self):
      communication_network = CommunicationNetwork([['A', 'B']])

      com_device_A = CommunicationSystem()
      com_device_A.set_agent_id('A')
      device_collection_A = list()
      device_collection_A.append(com_device_A)
      task_A = AverageConsensus([10.0, 0.5])
      task_A.set_agent_id('A')

      com_device_B = CommunicationSystem()
      com_device_B.set_agent_id('B')
      device_collection_B = list()
      device_collection_B.append(com_device_B)
      task_B = AverageConsensus([20.0, 0.5])
      task_B.set_agent_id('B')

      for i in range(0,2):
          device_collection_A[0].read_from_environment(Logger(False), communication_network)
          device_collection_B[0].read_from_environment(Logger(False), communication_network)

          device_collection_A = task_A.run_iteration(Logger(False), device_collection_A)
          device_collection_B = task_B.run_iteration(Logger(False), device_collection_B)

          communication_network = device_collection_A[0].write_to_environment(Logger(False), communication_network)
          communication_network = device_collection_B[0].write_to_environment(Logger(False), communication_network)

      mean_value = 15.0
      epsilon = 0.05
      task_A_value =  task_A.get_variable()
      task_B_value = task_B.get_variable()
      self.assertTrue(abs(task_A_value - mean_value) < epsilon)
      self.assertTrue(abs(task_B_value - mean_value)< epsilon)

if __name__ == '__main__':
    unittest.main()

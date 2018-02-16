#! /usr/bin/env python

import unittest

from mars.core import *
from mars.tasks import DummyTask


class AgentTestCase(unittest.TestCase):

    def test_BuildAgentSuccess(self):
        agent = Agent('A', DummyTask())

        self.assertEqual(agent.get_state(), Agent.State.STANDBY)
        self.assertEqual(agent.get_clock(), 0)

    def test_RunAgentSuccess(self):
        agent = Agent('A', DummyTask())
        agent.run_task(Logger(False))

        self.assertEqual(agent.get_state(), Agent.State.RUNNING)
        self.assertEqual(agent.get_clock(),1)


class SimulationSingleAgentTestCase(unittest.TestCase):

    def test_BuildSimulatorSuccess(self):
        simulation = Simulation(100)

        self.assertEqual(simulation.get_clock(),0)

    def test_SimulateReachesTimeHorizonSuccess(self):
        agent_collection = [Agent('A', DummyTask())]

        simulation = Simulation(100, agent_collection)

        self.assertTrue(simulation.run(Logger(False)))
        self.assertEqual(simulation.get_clock() - 1 , 100)

    def test_SimulateWithoutAgentFail(self):
        self.assertFalse(Simulation(100, list()).run(Logger(False)))


class SimulationMultipleAgentsTestCase(unittest.TestCase):

    def test_SimulateReachesTimeHorizonSuccess(self):
        agent_collection = [Agent('A', DummyTask()),
                            Agent('B', DummyTask())]

        simulation = Simulation(100,agent_collection)

        self.assertTrue(simulation.run(Logger(False)))
        self.assertEqual(simulation.get_clock() - 1, 100)


if __name__ == '__main__':
    unittest.main()


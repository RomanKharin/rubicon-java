from unittest.main import TestProgram
import unittest
import sys

if __name__ == '__main__':
    suite1 = unittest.defaultTestLoader.loadTestsFromName("tests.test_jni")
    suite2 = unittest.defaultTestLoader.loadTestsFromName("tests.test_rubicon")
    suite3 = unittest.defaultTestLoader.loadTestsFromName("tests.test_thread")
    suites = unittest.TestSuite([suite1, suite2, suite3])
    result = unittest.TextTestRunner(verbosity = 2).run(suites)
    sys.exit(not result.wasSuccessful())
    #TestProgram(argv=[__file__,'discover'], verbosity=2, module=None)

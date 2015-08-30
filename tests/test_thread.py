# -*- coding: utf-8 -*-
from __future__ import print_function, division, unicode_literals

from unittest import TestCase

from rubicon.java import JavaClass, JavaInterface
import rubicon

class ThreadTest(TestCase):

    def test_thread(self):

        ThreadRun = JavaClass('org/pybee/rubicon/test/ThreadRun')
        threadrun = ThreadRun("Test-thread-1")
        # insert variables to rubicon module to test inside another thread
        rubicon._test_rubicon = {"a": 100, "b": 1027}
        # start another thread via java
        threadrun.start_thread()
        # check if values are changed
        self.assertEqual(rubicon._test_rubicon["c"], 1127)


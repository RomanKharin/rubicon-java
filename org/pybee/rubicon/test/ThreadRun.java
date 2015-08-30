package org.pybee.rubicon.test;

import java.lang.System;
import java.lang.Thread;
import java.lang.Runnable;


import org.pybee.rubicon.Python;


public class ThreadRun {

    static public String name;

    public ThreadRun(String n) {
        name = n;
    }

    public String toString() {
        return name;
    }
    
    public void start_thread() {
        Thread thread = new Thread(new Runnable() {
                @Override
                public void run() {
                    System.out.println("Java thread: " + name);
                    // without this call JVM encounter SIGSEGV at PyImport_GetModuleDict
                    Object state = Python.thread_ensure();
                    if (Python.run("tests/threadrunner.py") != 0) {
                        System.err.println("Got an error running Python script (thread)");
                    }
                    System.out.println("Return from python script: " + name);
                    // without releasing main thread will wait forever 
                    // and program can't be finished
                    Python.thread_release(state);
                }
            });
        thread.start();
        // and wait thread ti finish
        try {
            System.out.println("Join to thread");
            thread.join();
            System.out.println("Joined");
        } catch (InterruptedException e) {
            System.err.println("Got an error while waiting Python thread");
        }
    }
}

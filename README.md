# simple_book_tracker

A new Flutter application.

This project uses the auth and firestore firebase services for data. 

In order to reduct reads/writes, I tried not to use streams and manage data locally as well as in the cloud. This turned out to be challenging, especially on offline mode. Everything is working perfectly and super fast online, but offline lacks error catching and the firebase cache is not implemeted properly. 

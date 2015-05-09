TestAppDelegate
===============

iOS testing, while possible, is still rather difficult when compared to other platforms like ruby and java/Android.(1)
Apple has made some progress but is still years behind.

One of the issues I have found is how test targets are executed alongside your application.  This can cause problems
when you are testing NSNotification posting and observing. (2)  The problem I have experienced with this is that you 
are trying to run some tests that publish or observe some event but you get interference with your app because it is 
publishing events or also observing.

TestAppDelegate shows a simple category that swizzles out application:didFinishLaunchingWithOptions to an empty impl.
This is nothing new; I am just posting this to help others.


(1) even though objective-c is older than Java and Ruby!
(2) Using raw NSNotifications is generally a smell as other patterns probably would be more applicable.  Or you could use
an observation framework like ESCObservable to at least define who publishes what and who listens to whom.

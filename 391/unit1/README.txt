My bounding box values are:
bottomleft box = 53.404750,-113.685867
top right box = 53.714084, -113.320182

Command used to run osmosis on bounding box is:
./bin/osmosis --read-pbf alberta-latest.osm.pbf --bounding-box bottom=53.404750 left=-113.685867 top=53.714084 right=-113.320182 --write-xml edmonton.osm

to run the code, type python3 assignment1.py
It will prompt you for the file name of the osm that you want to parse
and it will create a output database called test.db

Constraints are as follows:

Upon trying to update either way or waypoint, it isn't allowed
THis is because an update on either of them means that the ordinals would be messed up, and since we dont want that, we enforce the fact that they cannot update either way or waypoint

Upon trying to insert a waypoint, if the waypoint ordinal violates any of the following conditions, then the database will not allow it
If the ordinal trying to insert is greater than the max, or less then or equal to 0, then it does not allow it
Or if the ordinal already exists in the waypoint, then it is also not allowed

When trying to delete a waypoint, if the waypoint ordinal violates any of the following, it is not allowed.

If the user is trying to delete the last or the first ordinal, the database will not allow it since it violates the way open and close:


If the user truly wants to make edits, they would need to edit the XML file since the python program determine and maintains our necessary constraints.

-Eric Hsueh
-1384955

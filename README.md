# Switcher-Room-Combiner
Switcher Room Combiner lua plugin for the QSC Q-SYS platform.

This plugin mimics the room combiner component build into Q-SYS designer except that instead of mixing audio (combining audio sources) it combines (syncronises) switchers.  In addition to this it features Input Restriction mode that allows each room to only have access to a user definable number of switcher inputs.  When rooms are combined, their own allowed inputs are added to the group's allowed inputs, and each room is able to access the inputs of the other.  When the rooms are separated again they will revert back to the lowest numbered allowed input in their list.

Known limits - the room combine algorithm can become big and hits the execution limit when numbers of rooms, walls or room/wall associations gets too great.

# To dos:
* Optimise findRoomGroups() function to allow more rooms to work without hitting execution limit.
* Set debug.sethook() to remove the execution limit after significant testing.
* Allow user to specify own colours as properties (or at runtime?)
* Output/Input on a single pin all walls open & wall/room association info so downstream components don't need to run room finding algorithm.
* New property - "Allow toggle off: Yes/No".  This will allow a switcher input that is currently on to be toggled off.  This will also allow you to use the plugin with one input as a toggle-room-combiner, therefore syncing toggle states across rooms.
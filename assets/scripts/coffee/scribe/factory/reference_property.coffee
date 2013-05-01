#
# @author - Tim Shelburne <tim@musiconelive.com>
#
# a class to represent a property that references another datastore entity in metadata
#
class ReferenceProperty
  constructor: (@entityType, @entityId)->

return ReferenceProperty
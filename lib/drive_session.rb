require 'active_record'
# this would be the client's copy of the model
class DriveSession < ActiveRecord::Base
  self.primary_key = 'name'
  #attr_accessible :name, :last_updated, :rig_id, :du_id, :server_version, :capture_count, 
  #                :start_time, :end_time, :current_event  
  
  #has_many :events, class_name: 'DriveSessionEvent', foreign_key: "drive_session_name"
  #has_many :annotations, class_name: 'Annotation', foreign_key: "drive_session_id"  
end
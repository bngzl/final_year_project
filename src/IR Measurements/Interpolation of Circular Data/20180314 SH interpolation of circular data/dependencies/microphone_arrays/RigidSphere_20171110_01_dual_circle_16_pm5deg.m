classdef RigidSphere_20171110_01_dual_circle_16_pm5deg < RigidSphereArray & BinauralArray
    properties (SetAccess=protected)
        % properties from ElobesMicArray already implemented in SphericalHarmonicSoundFieldArray
        
        % properties from BinauralArray
        refChanLeft
        refChanRight
        channelsLeft
        channelsRight
    end
    methods
        function[obj] = RigidSphere_20171110_01_dual_circle_16_pm5deg()
            
            % use superclass to create the object with input parameter
            obj = obj@RigidSphereArray(0.09);
            
            % override the default properties of the superclass
            obj.sensorCartesianPositionsDefault = predefinedSensorPositions();
            obj.refChan = 0; % reference is the origin
            
            % populate the parameters
            obj.refChanLeft = 1;
            obj.refChanRight = 2;
            obj.channelsLeft = (1:2:length(obj.sensorCartesianPositionsDefault-1)).';
            obj.channelsRight = (2:2:length(obj.sensorCartesianPositionsDefault)).';            
        end
    end

end

function[sensor_pos] = predefinedSensorPositions()
% evaluate to determine the postitions of the elements relative to
% the origin
nMics = 16;
radius = 0.09;     % radius on which microphones lie [metres]
deg_from_horizontal = 5;

% to make it binaural all mics should be asssigned to left or right so
% spacing should be symmetric about the median plane
angular_spacing = 2*pi/(nMics/2);
az_left = angular_spacing/2 : angular_spacing : pi;
az_right = -az_left;

single_ring_az = [az_left;az_right];
up_inc = pi/2-deg2rad(deg_from_horizontal);
down_inc = pi/2+deg2rad(deg_from_horizontal);

up_inc = repmat(up_inc,size(single_ring_az));
down_inc = repmat(down_inc,size(single_ring_az));

az = reshape([single_ring_az;single_ring_az],[],1);
inc = reshape([up_inc;down_inc],[],1);

sensor_pos = radius * [cos(az).*sin(inc), sin(az).*sin(inc), cos(inc)]; % [x,y,z] offsets of sensors
end
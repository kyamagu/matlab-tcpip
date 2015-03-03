function bytes = serialize(obj)
%SERIALIZE Serialize a matlab object into a byte sequence.
%
%    bytes = serialize(obj)
%
% SERIALIZE takes arbitrary matlab object and encode it into a byte sequence.
% The result is given in a uint8 array.
%
% See also deserialize

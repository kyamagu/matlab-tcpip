function bytes = serialize(value)
%SERIALIZE Serialize a matlab object into a byte sequence.
%
%    bytes = serialize(value)
%
% SERIALIZE takes arbitrary matlab object and encode it into a byte sequence.
% The result is given in a uint8 array.
%
% See also deserialize
  loadlibmx();
  bytes = calllib('libmx', 'mxSerialize', value);
end

function value = deserialize(bytes)
%DESERIALIZE Decode a matlab object from a byte sequence.
%
%    value = deserialize(bytes)
%
% DESERIALIZE decodes matlab object from a byte sequence created by SERIALIZE.
%
% See also serialize
  loadlibmx();
  assert(isa(bytes, 'int8') || isa(bytes, 'uint8'), ...
         'Input must be int8 or uint8: %s', class(bytes));
  value = calllib('libmx', ...
                  'mxDeserialize', ...
                  typecast(bytes, 'uint8'), ...
                  numel(bytes));
end

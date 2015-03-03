function value = serializeOrValidate(options, value)
%SERIALIZEORVALIDATE Serialize or validate the input.
  if options.serialize
    value = serialize(value);
  else
    assert(isa(value, 'int8') || isa(value, 'uint8'), ...
           'Expected int8 or uint8: %s.', class(value));
  end
end

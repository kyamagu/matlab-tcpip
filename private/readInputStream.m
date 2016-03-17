function data = readInputStream(input_stream, buffer_size)
%READINPUTSTREAM Read bytes from the input stream.
  data_size = input_stream.read(8);
  assert(numel(data_size) == 8);
  data_size = typecast(data_size, 'uint64');
  data = zeros(1, data_size, 'int8');
  for i = 1:buffer_size:data_size
    offset = i - 1;
    read_size = min(buffer_size, data_size - offset);
    bytes = input_stream.read(int32(read_size));
    data(i:offset+read_size) = bytes;
  end
  data = typecast(data, 'uint8');
end

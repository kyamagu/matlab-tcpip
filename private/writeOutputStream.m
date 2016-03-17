function output_stream = writeOutputStream(output_stream, data, buffer_size)
%WRITEOUTPUTSTREAM Write bytes to the output stream.
  data_size = typecast(uint64(numel(data)), 'uint8');
  output_stream.write(data_size);  % Send the size first.
  for i = 1:buffer_size:numel(data)
    end_offset = min(numel(data), i + buffer_size - 1);
    output_stream.write(data(i:end_offset));
  end
end

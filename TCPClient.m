function response = TCPClient(hostname, port, request, varargin)
%TCPCLIENT Send a TCP request.
%
%    response = TCPClient(hostname, port, request, ...)
%
% Send a TCP request to a specified port of the host. Start a TCPSERVER process
% in the server side before making a client request.
%
% The function accepts a following option.
%
% * 'serialize' - Logical flag to automatically serialize Matlab variables in
%                 request and response. When false, a caller must give raw
%                 bytes to the function. Default true.
% * 'buffer_size' - Size of the internal buffer. Default 4096.
%
% Example
% -------
%
% Start a plus-1 server at port 3000 in a server process.
%
%    TCPServer(@(x)x+1, 'port', 3000);
%
% In a client process, send a request to the server running at localhost.
%
%    response = TCPClient('localhost', 3000, 1:5);
%    disp(response); % Shows 2:6.
%
% See also TCPSERVER
  error(nargchk(3, inf, nargin, 'struct'));
  assert(ischar(hostname), 'Hostname must be a string: %s.', class(hostname));
  assert(isnumeric(port), 'Port must be numeric: %s.', class(port))
  startup('WarnOnAddPath', true);

  % Get options.
  options = struct(...
    'serialize', true, ...
    'buffer_size', 4096 ...
    );
  options = getOptions(options, varargin{:});

  request = serializeOrValidate(options, request);
  socket = sendRequest(options, hostname, port, request);
  if nargout > 0
    response = receiveResponse(options, socket);
    response = deserializeAndValidate(options, response);
  else
    socket.close();
  end
end

function socket = sendRequest(options, hostname, port, request)
%SENDREQUEST Send a request.
  socket = java.net.Socket(hostname, port);
  % output_stream = java.io.BufferedOutputStream(socket.getOutputStream());
  output_stream = socket.getOutputStream();
  writeOutputStream(output_stream, request, options.buffer_size);
  output_stream.flush();
  socket.shutdownOutput();
end

function response = receiveResponse(options, socket)
%RECEIVERESPONSE Receive a server response.
  input_stream = matlab_tcpip.BufferedInputStreamWithRead(...
      socket.getInputStream(), int32(options.buffer_size));
  response = readInputStream(input_stream, options.buffer_size);
  input_stream.close();
end

function response = deserializeAndValidate(options, response)
%DESERIALIZEANDVALIDATE Deserialize the response and check an error.
  if options.serialize
    response = deserialize(response);
    if isa(response, 'MException')
      rethrow(response);
    end
  end
end

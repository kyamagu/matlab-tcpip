function TCPServer(callback, varargin)
%TCPSERVER Run a TCP server process.
%
%    TCPServer(callback, ...)
%    TCPServer(callback, 'port', 0, 'serialize', true, ...)
%
% TCPSERVER starts a TCP server process and respond to a request with a given
% function callback. Use TCPCLIENT to communicate with this process. The server
% process runs indefinite. Use Ctrl-C to quit the process.
%
% The function accepts following options.
%
% * 'port' - TCP port to use. When the port number is 0, the function picks up
%            any available port in the system. Default 0.
% * 'serialize' - Logical flag to automatically serialize Matlab variables in
%                 request and response.  When false, a callback function takes
%                 raw bytes and must return raw bytes in the output arguments.
%                 Default true.
% * 'onetime' - If true, terminate the server upon the first request. Default
%               false.
% * 'buffer_size' - Size of the internal buffer. Default 4096.
% * 'quiet' - Logical flag to suppress display messages. Default false.
%
% Any additional name-value arguments are passed to the provided function handle.
%
% Example
% -------
%
% Start a plus-1 server at port 3000.
%
%     TCPServer(@(x)x+1, 'port', 3000);
%
% Serve a custom callback function `dispatch` at port 5000.
%
%     TCPServer(@dispatch, 'port', 5000);
%
% Where, `dispatch` is a user-defined callback that takes a single input
% argument of a client request and returns a sigle output to be sent back to
% the client.
%
%     function response = dispatch(request)
%     %DISPATCH Process TCP/IP request.
%     ...
%
% See also TCPClient
  error(nargchk(1, inf, nargin, 'struct'));
  assert(ischar(callback) || isa(callback, 'function_handle'), ...
         'Input must be a function name or a function handle.');
  assert(nargin(callback) ~= 0, 'Function must take an argument.');
  assert(nargout(callback) ~= 0, 'Function must return an argument.');
  startup('WarnOnAddPath', true);

  % Get options.
  options = struct(...
    'port', 0, ...
    'serialize', true, ...
    'buffer_size', 4096, ...
    'onetime', false, ...
    'quiet', false ...
    );
  [options, varargin] = getOptions(options, varargin{:});

  % Start a main loop.
  server_socket = createSocket(options);
  while true
    try
      [request, client_socket] = receiveRequest(options, server_socket);
      request = deserializeIfNeeded(options, request);
      response = executeOrCatch(options, callback, request, varargin{:});
      response = serializeOrValidate(options, response);
      sendResponse(options, client_socket, response);
      if options.onetime
        server_socket.close();
        break
      end
    catch exception
      server_socket.close();
      rethrow(exception);
    end
  end
end

function server_socket = createSocket(options)
%CREATESOCKET Create a server socket.
  server_socket = java.net.ServerSocket(options.port);
  if ~options.quiet
    fprintf('[%s] Server starts at %s\n', ...
            datestr(now), ...
            char(server_socket.getLocalSocketAddress()));
  end
end

function [request, client_socket] = receiveRequest(options, server_socket)
%RECEIVETCPREQUEST Receive a TCP request.
  client_socket = server_socket.accept();
  input_stream = matlab_tcpip.BufferedInputStreamWithRead(...
      client_socket.getInputStream(), int32(options.buffer_size));
  request = readInputStream(input_stream, options.buffer_size);
  if ~options.quiet
    fprintf('[%s] Received %d bytes from %s\n', ...
            datestr(now), ...
            numel(request), ...
            char(client_socket.getLocalSocketAddress()));
  end
end

function request = deserializeIfNeeded(options, request)
%DESERIALIZEIFNEEDED Deserialize input if needed.
  if options.serialize
    request = deserialize(request);
  end
end

function response = executeOrCatch(options, callback, request, varargin)
%EXECUTEORCATCH Execute the callback with catch.
  try
    response = feval(callback, request, varargin{:});
  catch exception
    if ~options.quiet
      fprintf('%s', exception.getReport());
    end
    response = exception;
  end
end

function sendResponse(options, client_socket, response)
%RESPONDTCPREQUEST Respond to a TCP request.
  % output_stream = java.io.BufferedOutputStream(...
  %     client_socket.getOutputStream());
  output_stream = client_socket.getOutputStream();
  writeOutputStream(output_stream, response, options.buffer_size);
  output_stream.close();
end

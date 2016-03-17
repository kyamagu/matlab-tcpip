TCP/IP server and client for Matlab
===================================

This package contains a TCP/IP API for Matlab as well as data serialization
helpers. This package doesn't require `tcpip` function in the Instrument
Control Toolbox for Matlab, yet provides an equivalent functionality and a
simple-to-use API. This is suitable to communicate between multiple Matlab
instances over the TCP/IP network.

There are two high-level functions.

    TCPClient - Send a TCP request.
    TCPServer - Run a TCP server process.

Build
-----

Compile MEX files and Java helpers by the attached `Makefile`.

    make

Example
-------

Add a path to matlab-tcpip to use the API.

    addpath('/path/to/matlab-tcpip');

_Plus-1 server_

Start a plus-1 server at port 3000, which adds 1 to any given request.

    TCPServer(@(x)x+1, 'port', 3000);

Send a request to the server running at localhost on port 3000.

    response = TCPClient('localhost', 3000, 1); % Send `1`.
    disp(response); % Shows `2` from the plus-1 server.

_Custom callback_

Serve a custom callback function `dispatch` at port 5000.

    TCPServer(@dispatch, 'port', 5000);

Where, `dispatch` is a user-defined callback that takes a single input argument
of a client request and returns a single output sent back to the client.

    function response = dispatch(request)
    %DISPATCH Process a TCP/IP request.
    ...


API
---

_TCPServer_

    TCPServer(callback, ...)
    TCPServer(callback, 'port', 0, 'serialize', true, ...)

`TCPServer` starts a TCP server process and respond to a request with a given
function callback. Use `TCPClient` to communicate with this process. The server
runs indefinite. Use Ctrl-C to quit the process.

The function accepts the following options.

  * `port` - TCP port to use. When the port number is 0, the function picks up
             any available port in the system. Default 0.
  * `serialize` - Logical flag to automatically serialize Matlab variables in
                  request and response. When false, a callback function takes
                  raw bytes and must return raw bytes in the output arguments.
                  Default true.
  * `onetime` - If true, terminate the server upon the first request. Default
                false.
  * `buffer_size` - Size of the internal buffer. Default 4096.
  * `quiet` - Logical flag to suppress display messages. Default false.

_TCPClient_

    response = TCPClient(hostname, port, request, ...)

The function accepts the following option.

  * `serialize` - Logical flag to automatically serialize Matlab variables in
                  request and response. Default true.
  * `buffer_size` - Size of the internal buffer. Default 4096.

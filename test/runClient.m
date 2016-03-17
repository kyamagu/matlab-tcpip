addpath ..
startup
result = TCPClient('localhost', 3000, ones(1024,1024));
assert(all(result(:) == 2));

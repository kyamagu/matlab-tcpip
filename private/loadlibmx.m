function loadlibmx()
%LOADLIBMX Load the header file if not loaded yet.
  if ~libisloaded('libmx')
    header_file = fullfile(fileparts(mfilename('fullpath')), 'serialize.h');
    [notfound, warnings] = loadlibrary('libmx', header_file);
    assert(isempty(notfound), warnings);
  end
end
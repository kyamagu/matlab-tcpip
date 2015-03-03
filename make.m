function make(varargin)
%MAKE Build serialization library.
  root_dir = fullfile(fileparts(mfilename('fullpath')), 'private');
  files = dir(fullfile(root_dir, '*.cc'));
  for i = 1:numel(files)
    cmd = sprintf('mex -Iprivate -outdir %s %s%s', ...
                  root_dir, ...
                  fullfile(root_dir, files(i).name), ...
                  sprintf(' %s', varargin{:}));
    disp(cmd);
    eval(cmd);
  end
end

function [fpath] = canonicalPath(filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  file = java.io.File(filename);  
  fpath = char(file.getCanonicalPath());
  
  if file.exists()
      return
  else
      error('resolvePath:CannotResolve', 'Does not exist or failed to resolve absolute path for %s.', filename);
  end
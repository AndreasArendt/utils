function [fpath] = canonicalPath(filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here  
  fpath = char(java.io.File(filename).getCanonicalPath());
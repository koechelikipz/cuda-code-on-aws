% The 'LIB' configuration is used to generate a static library

% The 'packNGo' function gathers all the dependencies required by the 
% entry-point function into a single directory, for use at run-time.
% These dependencies are packaged into shared libraries for Linux.
% Since packNGo is used as a post codegen command, 2 directories are
% generated:

% 1. A zip folder containing all dependencies
% 2. A codegen directory containing the generated code

% Extract and copy all files in the zip folder to the codegen directory
% Ensure you have only 1 copy of main.cu and main.h in the codegen
% directory.

cfg = coder.gpuConfig('LIB');
cfg.TargetLang = 'C++';
cfg.DeepLearningConfig = coder.DeepLearningConfig('cudnn');
cfg.PostCodeGenCommand = 'packNGo(buildInfo,''fileName'',''classifier'');';

% Describe variable type and size using 'coder.typeof'
t = coder.typeof('a',[1 inf]);
codegen -config cfg alexnet_predict -args {t} -report

function p = mimroot()

if ispc
    p = 'z:/';
else
    p = system('echo $HOME');
end

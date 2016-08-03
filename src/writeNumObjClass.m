function writeNumObjClass(outdir, objects)

if ~exist(outdir, 'file'), mkdir(outdir); end;
global fid 
fid = fopen(fullfile(outdir, ['classes.tex']), 'w');

for obj=1:length(objects)
    pr('\\input{%s}\n', objects{obj});
end

fclose(fid);



function pr(varargin)
global fid;
fprintf(fid, varargin{:});
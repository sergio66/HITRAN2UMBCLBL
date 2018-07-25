function [buf] = odread_dbl(filename,endian);
%
% function [buf] = odread_dbl(filename,endian);
%
% Read  the OD files produced by LBLRTM in double precision file 
%
% Inputs: filename - name of OD file to read (ODexact_XXX)
%         endian - machine format type: 'l' stands for little-endian and 'b'stands for big-endian 
% Outputs: data - a structure containing all the TAPE12 data
%	data.filename		name of OD file
%	data.file_header	misc info [cell]
%	data.file_type		single or double panel
%	data.n_panels		# panels read
%	data.n_pts_read		# spectral points read
%	data.panel_header	panel header info [cell]
%	data.od         Optical depth
%	data.v1			min wavenumber (exact)
%	data.v2			max wavenumber (exact)
%	data.v			wavenumbers (exact)
%
% DCT 9/5/97
%%%%%% Modified for the double precision files and for the machine format type 
%%%%%% by Guido Masiello 08/08/03
%%%%%% Modified for the Optical depth
%%%%%% by Guido Masiello 04/12/2008


% READ THE OD FILE
% open the file as read only and binary format
fid = fopen(filename,'r');
buf.filename = filename;
%-----------------------------------------------------------------------
%  read in file_header
%-----------------------------------------------------------------------
% read in 4 bytes before and after every record
junk = fread(fid,4,'char');
buf.file_header.user_id = setstr(fread(fid,80,'uchar'))';
buf.file_header.secant = fread(fid,1,'float64');
buf.file_header.p_ave = fread(fid,1,'float64');
buf.file_header.t_ave = fread(fid,1,'float64');
molecule_id = zeros(64,8);

for i = 1:64;
    molecule_id(i,:)= fread(fid,8,'uchar')';
end
buf.file_header.molecule_id = setstr(molecule_id);
buf.file_header.mol_col_dens = fread(fid,64,'float64');
buf.file_header.broad_dens = fread(fid,1,'float64');
buf.file_header.dv = fread(fid,1,'float64');
buf.file_header.v1 = fread(fid,1,'float64');
buf.file_header.v2 = fread(fid,1,'float64');
buf.file_header.t_bound = fread(fid,1,'float64');
buf.file_header.emis_bound = fread(fid,1,'float64');

if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.hirac = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.lblf4 = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.xscnt = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.aersl = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.emit = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.scan = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.plot = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.path = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.jrad = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.test = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.merge = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
buf.file_header.LBL_id.scnid = fread(fid,1,'float64');
buf.file_header.LBL_id.hwhm = fread(fid,1,'float64');
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.idabs = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.atm = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.layr1 = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.LBL_id.nlayr = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.n_mol  = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end
if endian=='b';    gm = fread(fid,1,'int');end
    buf.file_header.layer = fread(fid,1,'int');
if endian=='l';    gm = fread(fid,1,'int');end

buf.file_header.yi1 = fread(fid,1,'float64');

yid = zeros(10,8);
for i = 1:10;yid(i,:) = fread(fid,8,'char')';end
buf.file_header.yid = setstr(yid(1:7,:));
% read in 4 bytes before and after every record
junk = fread(fid,4,'char');
clear molecule_id yid i
% set file_type to "Double"
buf.file_type = 'DOUBLE';
% Estimate number of spectral points and initialize arrays
n_pts_estimate=ceil((buf.file_header.v2-buf.file_header.v1)/buf.file_header.dv +1.5);
opdt = zeros(n_pts_estimate,1);
%-----------------------------------------------------------------------
%  read data panel by panel
%-----------------------------------------------------------------------
% initialize counters
buf.n_panels = 0;
buf.n_pts_read = 0;
% While not end-of-file, read the next panel
end_of_file = 0;
while end_of_file == 0
    % check for end of file
    end_of_file = feof(fid);
    % --------------------------------------------------------
    % read in panel header
    % --------------------------------------------------------
    % read in 4 bytes before and after every record
    junk = fread(fid,4,'char');
    buf.panel_header.v1{buf.n_panels+1} = fread(fid,1,'float64');
    buf.panel_header.v2{buf.n_panels+1} = fread(fid,1,'float64');
    buf.panel_header.dv{buf.n_panels+1} = fread(fid,1,'float64');
    if endian=='b';    gm = fread(fid,1,'int');  end
       buf.panel_header.n_pts{buf.n_panels+1} = fread(fid,1,'int');
    if endian=='l';    gm = fread(fid,1,'int'); end

    % read in 4 bytes before and after every record
    junk = fread(fid,4,'char');
    % --------------------------------------------------------
    % read current panel data
    % --------------------------------------------------------
    if buf.panel_header.n_pts{buf.n_panels+1} ~= -99
        switch upper(buf.file_type)
            case 'DOUBLE',
                junk = fread(fid,4,'char');
                od = fread(fid,buf.panel_header.n_pts{buf.n_panels+1},'float64');
                junk = fread(fid,4,'char');
                pt1 = buf.n_pts_read + 1;
                pt2 = buf.n_pts_read + buf.panel_header.n_pts{buf.n_panels+1};
                opdt(pt1:pt2) = od;
                clear od
                % increment number of points read
                buf.n_pts_read = buf.n_pts_read + ...
                    buf.panel_header.n_pts{buf.n_panels+1};
                % increment panel number
                buf.n_panels = buf.n_panels +1;
        end
    end
end  % on end-of-file while loop
buf.od = opdt(1:buf.n_pts_read);
buf.v1 = buf.panel_header.v1{1};
buf.v2 = buf.panel_header.v2{buf.n_panels};
buf.v = linspace(buf.v1,buf.v2,buf.n_pts_read)';
fclose(fid);
% END OF READING THE OD FILE
return

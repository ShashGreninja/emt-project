%patch length
%The effective length of the patch determines the resonant frequency.
 
c = 299792458;
%l_eff = c/(2*f0*sqrt(e_eff));
 
%But the actual physical length is slightly shorter than l_eff because of fringing fields at the patch edges.
%lp = l_eff-2*del_l;
%del_l = (0.412 * ((epsilon_eff + 0.3) * (Wp/h + 0.264)) / ((epsilon_eff - 0.258) * (Wp/h + 0.8)))*h;
 
%Wp = (c ./ (2 .* f0)) .* sqrt(2 ./ (epsilon_r + 1));
 
%Wp defined depended on er; 
%delL/h upon eps_eff, Wp, h; 
% lp upon l_eff, del_l;
 
 
 
 
 
% --- parameters (example values) ---
Lp = 38e-3;   % patch length
Wp = 29e-3;   % patch width
W_line = 3e-3; % microstrip width (50 ohm)
L_line = 20e-3; % microstrip length extending from patch
h = 1.6e-3;    % substrate thickness
 
% Patch rectangle (centered at origin)
patch_x = [-Lp/2, Lp/2, Lp/2, -Lp/2];
patch_y = [-Wp/2, -Wp/2, Wp/2, Wp/2];
 
% Microstrip rectangle — attach to patch at patch's +x edge
% Position microstrip so its near edge aligns with patch's right edge
ms_x0 = Lp/2;          % x coordinate of patch edge
ms_x = [ms_x0, ms_x0 + L_line, ms_x0 + L_line, ms_x0];
% center microstrip in y (or offset if you want off-center feed)
ms_y = [-W_line/2, -W_line/2, W_line/2, W_line/2];
 
% Create polyshape objects and union them (MATLAB core)
p1 = polyshape(patch_x, patch_y);
p2 = polyshape(ms_x, ms_y);
p_union = union(p1, p2);
 
%just need to convert your polyshape (from union operation)
%into an antenna.Polygon before giving it to pcbStack.
 
% Suppose your unioned shape is p_union (a polyshape)
[xv, yv] = boundary(p_union);   % extract vertex coordinates
% Now create the antenna.Polygon properly
topMetal = antenna.Polygon('Vertices', [xv, yv]);
 
% Visual check
figure; plot(p_union); axis equal;
title('Top copper (patch + microstrip) union');
class(p_union);
class(topMetal);
 
figure;
show(topMetal);
title('Top copper polygon');
 
% Next: convert this top copper polygon into an Antenna Toolbox object.
%using pcbStack (top layer as 'p_union') to build a full PCB/antenna model
 
 
 
%now pcbstack computes fields, impedance, and S-parameters.

function [pix_to_m_scaled] = getScalingPixToM(s)

% s : scale of the image in meters; scale = 1:3000 => s=3000
% pix_to_m_scaled : factor which converts pixels to meters corresponding to
% the scale s. Unit m/pix. 
pix_per_inch=get(groot, 'ScreenPixelsPerInch');
m_per_inch=2.54*10^(-3);

pix_to_m_scaled=s*m_per_inch/pix_per_inch;



end


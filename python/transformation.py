import math
import numpy as np

# Constants for WGS84
a = 6378137.0  # semi-major axis
f = 1 / 298.257223563  # flattening
e2 = 2 * f - f ** 2  # square of eccentricity

def M_x(phi):    
    s = math.sin(phi)
    c = math.cos(phi)
    
    return np.matrix([[ 1,  0,  0], [0,  c, -s], [0,  s,  c]])
                    
def M_y(theta):
    s = math.sin(theta)
    c = math.cos(theta)

    return np.matrix([[ c,  0,  s], [0,  1, 0], [-s,  0,  c]])

def M_z(psi):
    s = np.sin(psi)
    c = np.cos(psi)

    return np.matrix([[ c,  -s,  0], [s,  c, 0], [0,  0,  1]])

def ecef_to_enu(lat_rad, lon_rad, x_E_m, y_E_m, z_E_m):
    Mx = M_x(np.pi/2 - lat_rad)
    Mz = M_z(np.pi/2 + lon_rad)
    
    p_E = np.array([x_E_m, y_E_m, z_E_m]).T

    ENU = []
    for xyz in p_E:
        ENU.append(np.dot(np.dot(Mx.T, Mz.T), xyz))

    return np.stack(ENU)[:,0], np.stack(ENU)[:,1], np.stack(ENU)[:,2]    

def wgs84_to_ned(lat_rad, lon_rad, alt_m):
    [x_E, y_E, z_E] = wgs84_to_ecef(lat_rad, lon_rad, alt_m)
    
    [xref_E, yref_E, zref_E] = wgs84_to_ecef(lat_rad[0], lon_rad[0], alt_m[0])

    delta_x = [x - xref_E[0] for x in x_E] 
    delta_y = [y - yref_E[0] for y in y_E] 
    delta_z = [z - zref_E[0] for z in z_E] 

    [e, n, u] = ecef_to_enu(lat_rad[0], lon_rad[0], delta_x, delta_y, delta_z)

    return  n, e, -u

def wgs84_to_ecef(lat_rad, lon_rad, alt_m):
    """
    Convert WGS84 coordinates to ECEF.
    
    Parameters:
    lat_rad -- Latitude in radiant
    lon_rad -- Longitude in radiant
    alt_m -- Altitude in meters
    
    Returns:
    x, y, z -- ECEF coordinates in meters
    """

    x = []
    y = []
    z = []
    
    if not hasattr(lat_rad, "__len__"):        
        lat_rad = [lat_rad]
        lon_rad = [lon_rad]
        alt_m = [alt_m]
    
    for ii in range(0, len(lat_rad)):
        # Calculate N
        N = a / math.sqrt(1 - e2 * math.sin(lat_rad[ii]) ** 2)
        
        # Calculate ECEF coordinates
        x.append((N + alt_m[ii]) * math.cos(lat_rad[ii]) * math.cos(lon_rad[ii]))
        y.append((N + alt_m[ii]) * math.cos(lat_rad[ii]) * math.sin(lon_rad[ii]))
        z.append((N * (1 - e2) + alt_m[ii]) * math.sin(lat_rad[ii]))
            
    return x, y, z

def ecef_to_wgs84(x, y, z):
    """
    Convert ECEF coordinates to WGS84 (latitude, longitude, altitude).
    
    Parameters:
    x, y, z - ECEF coordinates in meters
    
    Returns:
    lat - Latitude in degrees
    lon - Longitude in degrees
    alt - Altitude in meters
    """
    # Calculate longitude
    lon = math.atan2(y, x)

    # Calculate the hypotenuse from the z-axis
    hyp = math.sqrt(x**2 + y**2)
    
    # Iteratively calculate latitude and altitude
    lat = math.atan2(z, hyp * (1 - e2))
    N = a / math.sqrt(1 - e2 * math.sin(lat)**2)
    alt = hyp / math.cos(lat) - N
    
    lat_prev = 0
    while abs(lat - lat_prev) > 1e-12:
        lat_prev = lat
        N = a / math.sqrt(1 - e2 * math.sin(lat)**2)
        alt = hyp / math.cos(lat) - N
        lat = math.atan2(z, hyp * (1 - e2 * (N / (N + alt))))        
    
    return lat, lon, alt
puts("Warden 120/150mm arty calculator w/ wind by [FMAT] Skittles V1.0 (should? work)")
puts("Enter arty gun distance to target")

arty_distance = gets.chomp.to_f
puts("Enter arty gun azim (in-game azim) to target")
arty_azim = (gets.chomp.to_f)%360
puts("Enter wind level (0-5)")
wind_lvl = gets.chomp.to_i

if wind_lvl > 5
    puts("Wind entered too high, maxxing to 5")
    wind_lvl = 5
elsif wind_lvl < 0
    puts("Wind entered negative, setting to 0")
end

puts("Enter wind azim (from direction of wind)")
wind_azim = (gets.chomp.to_f)%360

#Basic Polarization of coordinates b/c arty is a sphere
def convert_azim_to_rad(azim) #azim = degree but foxhole is stupid in how it does it
    calc_num = ((azim - 180) + 90).abs
    if azim.between?(90.0,270.0)
       calc_num = -1 * calc_num + 360
    elsif azim.between?(270.0,360.0)
        calc_num = 360 - calc_num
    end
    return ((calc_num % 360) * Math::PI/180)
end 
#not entirely sure if it works, but I tested (most?) edge cases? (For both above and below lmao)
def convert_rad_to_azim(radian)
    calc_num = ((radian * 180)/Math::PI) % 360
    puts(calc_num)
    if calc_num.between?(0.0, 90.0)
        puts("phase 1")
        calc_num = calc_num * -1 + 90
    elsif calc_num.between?(90.0, 180.0)
        puts("phase 2")
        calc_num = calc_num * -1 + 90
    elsif calc_num < 0
        puts("negative lol")
        calc_num = calc_num + 180
    end


    return calc_num
end #

def wind_factorization(arty_azim, arty_distance, wind_azim, wind_lvl)
    #arty de-polarization into x & y
    arty_rad_conv = convert_azim_to_rad(arty_azim)
    arty_vector_x = (arty_distance * Math.cos(arty_rad_conv))
    arty_vector_y = (arty_distance * Math.sin(arty_rad_conv))

    #wind de-polarization into x & y
    wind_rad_conv = convert_azim_to_rad(wind_azim)
    wind_mag = wind_lvl * 10
    wind_vector_x = wind_mag * Math.cos(wind_rad_conv)
    wind_vector_y = wind_mag * Math.sin(wind_rad_conv)

    #vector subtraction to find solution

    #opposite wind vector
    adj_wind_vector_x = wind_vector_x * -1
    adj_wind_vector_y = wind_vector_y * -1
    #solving soln
    solved_vector_x = arty_vector_x + adj_wind_vector_x
    solved_vector_y = arty_vector_y + adj_wind_vector_y

    solved_vector_mag = Math.sqrt((solved_vector_x*solved_vector_x) + (solved_vector_y*solved_vector_y))
    solved_vector_theta = Math.atan2(solved_vector_y,solved_vector_x)
    solved_vector_theta_degree = convert_rad_to_azim(solved_vector_theta) #PAIN

    puts("Your updated firing solution is ready")
    puts("DISTANCE: " + solved_vector_mag.to_s )
    puts("AZIMUTH: " + solved_vector_theta_degree.to_s )

end

wind_factorization(arty_azim, arty_distance, wind_azim, wind_lvl)

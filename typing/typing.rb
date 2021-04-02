def typing(str, speed, wait_time, num_new_lines=1, realistic=false)
    if realistic
        str.each_char do |char|
            modifier = [2.0,4.0,6.0,8.0].sample
            sleep(modifier/speed)
            print char
        end
    else
        str.each_char do |char|
            sleep(1.0/speed)
            print char
        end
    end

    sleep(wait_time)

    if num_new_lines >= 0
        num_new_lines.times { |n| print "\n" }
    end

end

system("clear")

typing("Hello world",40,2,2,true)
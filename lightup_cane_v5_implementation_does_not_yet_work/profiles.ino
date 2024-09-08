void toggle_profiles() {
  preferences.clear();
  preferences.putInt("lastProfile", profiles.number);
  Serial.println(profiles.number);
  if(power){
    switch(profiles.number){
      case 1:
      // EXAMPLE of profile
      // List of all possible changes possible within a profile.
      // In essence: here you can change all user_settings on the fly
      // by changing the profiles.number variable.

      // NOTE: to use this and other profiles,
      // SET the 'MAX_NUMBER_OF_PROFILES' to 2 or higher

        haptic_on_times = 1; //Number of vibrations when light is turned on
        haptic_off_times = 2; //Number of vibrations when light is turned off
        buzzer_on_times = 1; //Number of beeps when light is turned on
        buzzer_off_times = 2; //Number of beeps when light is turned off
        haptic_profiles_times = 3; //Number of vibrations when profile is changed
        buzzer_profiles_times = 3; //Number of beeps when profile is changed

        profiles.frequency = 100000;      //Frequency of buzzer
        profiles.angle = 2000;            //Angle threshold of the IMU
        profiles.time_change_profile = 1500; // LONG press threshold
        profiles.time_battery_status = 500;  // MEDIUM press threshold
        profiles.intensity_haptic = 80.0; //Intenisty of vibrations (0% to 100%)
        profiles.intensity_buzzer = 80.0; //Intensity of buzzer (0% to 100%)
        profiles.intensity_led    = 50.0; //Intensity of lights (0% to 100%)
        saveProfileSettings(); // Save all profile settings to flash memory when it changes
        break;
      case 2:
        
        haptic_on_times = 2; //Number of vibrations when light is turned on
        haptic_off_times = 3; //Number of vibrations when light is turned off
        buzzer_on_times = 2; //Number of beeps when light is turned on
        buzzer_off_times = 3; //Number of beeps when light is turned off
 
        profiles.intensity_haptic = 80.0; //Intenisty of vibrations (0% to 100%)
        profiles.intensity_buzzer = 80.0; //Intensity of buzzer (0% to 100%)

        saveProfileSettings(); // Save all profile settings to flash memory when it changes

        break;
      case 3:
        
        //your changes..
 
        break;
      case 4:
        
        //your changes..

        break;
      case 5:
        
        //your changes..

        break;
      case 6:
        
        //your changes..

        break;
      case 7:
        
        //your changes..

        break;
      case 8:
        
        //your changes..

        break;
      case 9:
        
        //your changes..
 
        break;
      case 10:
        
        //your changes..

        break;

      default:
        
        break;
    }
    
    profiles.intensity_haptic = int(calc_intensity(profiles.intensity_haptic));
    profiles.intensity_buzzer = int(calc_intensity(profiles.intensity_buzzer));
    profiles.intensity_led    = int(calc_intensity(profiles.intensity_led));     
  }
}

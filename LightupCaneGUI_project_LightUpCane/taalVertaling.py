import serial
import time
import tkinter as tk
from tkinter import PhotoImage
from tkinter import StringVar
import threading
import serial.tools.list_ports

global TempString

global batteryStatusVar
global lightIntensityVar
global buzzerIntensityVar
global buzzerHzVar
global hapticIntensityVar
global lightOnOffVar

batteryStatusVar = "ERROR"
lightIntensityVar = "ERROR"
buzzerIntensityVar = "ERROR"
buzzerHzVar = "ERROR"
hapticIntensityVar = "ERROR"
lightOnOffVar = "ERROR"

# Define the correct password
correct_caneNumber = "001"

# Profile data
profiles = {
    "Profile 2": {
        "name": "Hannah",
    },
    "Profile 1": {
        "name": "Leo",
    }
}

# Translations
translations = {
    "en": {
        "project_name": "Light-up Cane",
        "start_text": "Please connect your LightupCane!",
        "next": "Next",
        "enter_cane_number": "Enter Cane Number:",
        "login": "Login",
        "incorrect_cane_number": "Incorrect cane number. Please try again.",
        "display_screen": "Display Screen",
        "battery_status": "Battery Status: ",
        "light_intensity": "Light Intensity: ",
        "buzzer_intensity": "Buzzer Intensity: ",
        "buzzer_hz": "Buzzer Hz: ",
        "haptic_intensity": "Haptic Intensity: ",
        "light_on_off": "Light On/Off: ",
        "go_back": "Go Back",
        "profile_screen": "Profile Screen",
        "select_profile": "Select Profile:",
        "name": "Name:",
        "settings_screen": "Settings Screen",
        "change_settings": "Change settings",
        "battery_status_indication": "Battery status indication",
        "toggle_light": "Toggle light",
        "pressed_for": "Pressed for > ",
        "seconds": " seconds",
        "battery_life": ["1 beep-vibration", "2 beeps-vibrations", "3 beeps-vibrations", "4 beeps-vibrations"],
        "haptic_intensity": "Haptic intensity",
        "buzzer_intensity": "Buzzer intensity",
        "buzzer_frequency": "Buzzer frequency: ",
        "close": "Close",
        "profile": "Profile",
        "display": "Display",
        "settings": "Settings",
        "language": "Language",
    },
    "nl": {
        "project_name": "Oplichtende Stok",
        "start_text": "Sluit uw Oplichtende Stok aan!",
        "next": "Volgende",
        "enter_cane_number": "Voer Stok Nummer in:",
        "login": "Inloggen",
        "incorrect_cane_number": "Onjuist stoknummer. Probeer het opnieuw.",
        "display_screen": "Schermweergave",
        "battery_status": "Batterijstatus: ",
        "light_intensity": "Lichtintensiteit: ",
        "buzzer_intensity": "Zoemerintensiteit: ",
        "buzzer_hz": "Zoemer Hz: ",
        "haptic_intensity": "Haptische Intensiteit: ",
        "light_on_off": "Licht Aan/Uit: ",
        "go_back": "Ga Terug",
        "profile_screen": "Profielscherm",
        "select_profile": "Selecteer Profiel:",
        "name": "Naam:",
        "settings_screen": "Instellingen Scherm",
        "change_settings": "Instellingen wijzigen",
        "battery_status_indication": "Batterijstatus indicatie",
        "toggle_light": "Licht aan/uit",
        "pressed_for": "Ingedrukt voor > ",
        "seconds": " seconden",
        "battery_life": ["1 piep-vibratie", "2 piepen-vibraties", "3 piepen-vibraties", "4 piepen-vibraties"],
        "haptic_intensity": "Haptische intensiteit",
        "buzzer_intensity": "Zoemerintensiteit",
        "buzzer_frequency": "Zoemer frequentie: ",
        "close": "Sluiten",
        "profile": "Profiel",
        "display": "Weergave",
        "settings": "Instellingen",
        "language": "Taal",
    },
}

arduino = serial.Serial(port='COM7', baudrate=9600, timeout=1)

current_language = "en"
def rootMainLoop():
    def option_selected(ScreenName, LabelName ,selection):          
            message = ScreenName + "$" + LabelName + "$" + selection
            arduino.write(message.encode())
            
    def translate(text):
        return translations[current_language].get(text, text)

    def switch_language():
        global current_language
        current_language = "nl" if current_language == "en" else "en"
        update_texts()

    def update_texts():
        project_name_label.config(text=translate("project_name"))
        start_label.config(text=translate("start_text"))
        next_button.config(text=translate("next"))
        caneNumber_label.config(text=translate("enter_cane_number"))
        login_button.config(text=translate("login"))
        error_label.config(text="")
        display_label.config(text=translate("display_screen"))
        battery_status_label.config(text=translate("battery_status"))
        light_intensity_label.config(text=translate("light_intensity"))
        buzzer_intensity_label.config(text=translate("buzzer_intensity"))
        buzzer_hz_label.config(text=translate("buzzer_hz"))
        haptic_intensity_label.config(text=translate("haptic_intensity"))
        light_on_off_label.config(text=translate("light_on_off"))
        go_back_button_display.config(text=translate("go_back"))
        profile_label.config(text=translate("profile_screen"))
        profile_label.config(text=translate("select_profile"))
        profile_label.config(text=translate("name"))
        settings_label.config(text=translate("settings_screen"))
        go_back_button_profile.config(text=translate("go_back"))
        go_back_button_settings.config(text=translate("go_back"))
        button2.config(text=translate("profile"))
        button1.config(text=translate("display"))
        button3.config(text=translate("settings"))
        close_button.config(text=translate("close"))
        language_button.config(text=translate("language"))

    def authenticate():
        entered_caneNumber = caneNumber_entry.get()
        if entered_caneNumber == correct_caneNumber:
            # If the cane number is correct, show the main screen
            show_main_screen()
        else:
            # If the cane number is incorrect, update the error label
            error_label.config(text="Incorrect cane number. Please try again.")

    def on_button_click(button_number):
        if button_number == 1:
            show_display_screen()
        elif button_number == 2:
            show_profile_screen()
        else:
            show_settings_screen()


    def show_start_screen():
        start_frame.pack()
        main_frame.pack_forget()
        display_frame.pack_forget()
        profile_frame.pack_forget()
        settings_frame.pack_forget()
        hide_login_screen()

    def hide_start_screen():
        start_frame.pack_forget()

    def show_login_screen():
        login_frame.pack()

    def hide_login_screen():
        login_frame.pack_forget()

    def start_next():
        hide_start_screen()
        show_login_screen() 

    def show_main_screen():
        main_frame.pack()
        display_frame.pack_forget()
        profile_frame.pack_forget()
        settings_frame.pack_forget()
        hide_all_settings_frames()
        hide_login_screen()
        

    def show_display_screen():
        main_frame.pack_forget()
        display_frame.pack(expand=True, fill="both")  
        profile_frame.pack_forget()
        settings_frame.pack_forget()
        update_display_values() 

    def update_display_values():
        global batteryStatusVar
        global lightIntensityVar
        global buzzerIntensityVar
        global buzzerHzVar
        global hapticIntensityVar
        global lightOnOffVar

        battery_status_var.set(batteryStatusVar)
        light_intensity_var.set(lightIntensityVar)
        buzzer_intensity_var.set(buzzerIntensityVar)
        buzzer_hz_var.set(buzzerHzVar)
        haptic_intensity_var.set(hapticIntensityVar)
        light_on_off_var.set(lightOnOffVar)

    def show_profile_screen():
        main_frame.pack_forget()
        display_frame.pack_forget()
        profile_frame.pack()
        settings_frame.pack_forget()
        # Display profile information
        display_profile_info()

    def display_profile_info():
        profile_name = profile_var.get()
        entry_name_profile.delete(0, tk.END)  # Update to your entry widget in the profile frame
        entry_name_profile.insert(0, profiles[profile_name]["name"])  # Update to your entry widget in the profile frame


    def show_settings_screen():
        main_frame.pack_forget()
        display_frame.pack_forget()
        profile_frame.pack_forget()
        settings_frame.pack()
        show_settings_options()

    def show_settings_options():
        for button in settings_buttons:
            button.pack(pady=5)

    def on_settings_button_click(part):
        if part == "Button":
            show_button_settings()
        elif part == "Battery":
            show_battery_settings()
        elif part == "Light":
            show_light_settings()
        elif part == "Properties":
            show_properties_settings()

    def show_button_settings():
        hide_all_settings_frames()
        settings_frame.pack_forget()
        button_settings_frame.pack()


    def show_battery_settings():
        hide_all_settings_frames()
        settings_frame.pack_forget()
        battery_settings_frame.pack()


    def show_light_settings():
        hide_all_settings_frames()
        settings_frame.pack_forget()
        light_settings_frame.pack()


    def show_properties_settings():
        hide_all_settings_frames()
        settings_frame.pack_forget()
        properties_settings_frame.pack()

    def go_back_to_settings():
        hide_all_settings_frames()
        settings_frame.pack()

    def hide_all_settings_frames():
        for frame in settings_frames:
            frame.pack_forget()

    def go_back():
        show_main_screen()

    def close_program():
        root.destroy()

    # Create the main window
    root = tk.Tk()
    root.title("LightUpCane")
    root.configure(bg="white")  

    # Set the window to full screen
    root.attributes('-fullscreen', True)

    # Create toolbar frame
    toolbar_frame = tk.Frame(root, bg="black")  
    toolbar_frame.pack(side="top", fill="x")

    # Create language button
    language_button = tk.Button(toolbar_frame, text=translate("language"), command=switch_language, bg="black", fg="white")
    language_button.pack(side="right", padx=10, pady=5)


    # Add project name label to a frame with black background
    project_name_frame = tk.Frame(toolbar_frame, bg="black")
    project_name_frame.pack(padx=10, pady=5)
    project_name_label = tk.Label(project_name_frame, text="Light-up Cane", bg="black", fg="white", font=("Arial", 24))  
    project_name_label.pack()

    # Create start frame
    start_frame = tk.Frame(root, bg="black")
    start_label = tk.Label(start_frame, text="Please connect your LightupCane!", bg="black", fg="light blue", font=("Arial", 15))
    start_label.pack(pady=50)

    # Load and display the image
    image = PhotoImage(file="LightupCane.png")
    image = image.subsample(3, 3)
    image_label = tk.Label(start_frame, image=image, bg="black")
    image_label.pack()

    next_button = tk.Button(start_frame, text="Next", command=start_next, bg="white", fg="black", width=20, font=("Arial", 14))
    next_button.pack(side="bottom", pady=50, anchor="s")

    # Pack the start frame
    start_frame.pack(expand=True, fill="both")

    # Create login frame
    login_frame = tk.Frame(root, bg="white")
    caneNumber_label = tk.Label(login_frame, text="Enter Cane Number:", bg="white", font=("Arial", 14))
    caneNumber_label.pack(pady=10)
    caneNumber_entry = tk.Entry(login_frame, show="*")
    caneNumber_entry.pack(pady=5)
    login_button = tk.Button(login_frame, text="Login", command=authenticate, bg="black", fg="white", font=("Arial", 14))
    login_button.pack(pady=5)

    # Create a label to display error messages
    error_label = tk.Label(login_frame, text="", fg="red", font=("Arial", 12))
    error_label.pack()

    # Create main frame
    main_frame = tk.Frame(root, bg="white")


    # Create display frame
    display_frame = tk.Frame(root, bg="white")
    display_label = tk.Label(display_frame, text="Display Screen", bg="white", font=("Arial", 30, "bold"))  
    display_label.pack(pady=(50, 20))  

    # Create a frame to hold the display values
    display_values_frame = tk.Frame(display_frame, bg="white")
    display_values_frame.pack(pady=20)

    # Battery Status
    battery_frame = tk.Frame(display_values_frame, bg="white")
    battery_frame.pack(pady=10)
    battery_icon_label = tk.Label(battery_frame, text="🔋", bg="white", font=("Arial", 24))
    battery_icon_label.pack(side="left", padx=(0, 10))
    battery_status_label = tk.Label(battery_frame, text="Battery Status: ", bg="white", font=("Arial", 18))
    battery_status_label.pack(side="left")
    battery_status_var = tk.StringVar()
    battery_status_value = tk.Label(battery_frame, textvariable=battery_status_var, bg="white", font=("Arial", 18))
    battery_status_value.pack(side="left")

    # Light Intensity
    light_frame = tk.Frame(display_values_frame, bg="white")
    light_frame.pack(pady=10)
    light_icon_label = tk.Label(light_frame, text="💡", bg="white", font=("Arial", 24))
    light_icon_label.pack(side="left", padx=(0, 10))
    light_intensity_label = tk.Label(light_frame, text="Light Intensity: ", bg="white", font=("Arial", 18))
    light_intensity_label.pack(side="left")
    light_intensity_var = tk.StringVar()
    light_intensity_value = tk.Label(light_frame, textvariable=light_intensity_var, bg="white", font=("Arial", 18))
    light_intensity_value.pack(side="left")

    # Buzzer Intensity
    buzzer_frame = tk.Frame(display_values_frame, bg="white")
    buzzer_frame.pack(pady=10)
    buzzer_icon_label = tk.Label(buzzer_frame, text="🔊", bg="white", font=("Arial", 24))
    buzzer_icon_label.pack(side="left", padx=(0, 10))
    buzzer_intensity_label = tk.Label(buzzer_frame, text="Buzzer Intensity: ", bg="white", font=("Arial", 18))
    buzzer_intensity_label.pack(side="left")
    buzzer_intensity_var = tk.StringVar()
    buzzer_intensity_value = tk.Label(buzzer_frame, textvariable=buzzer_intensity_var, bg="white", font=("Arial", 18))
    buzzer_intensity_value.pack(side="left")

    # Buzzer Hz
    buzzer_hz_frame = tk.Frame(display_values_frame, bg="white")
    buzzer_hz_frame.pack(pady=10)
    buzzer_hz_icon_label = tk.Label(buzzer_hz_frame, text="🔊", bg="white", font=("Arial", 24))
    buzzer_hz_icon_label.pack(side="left", padx=(0, 10))
    buzzer_hz_label = tk.Label(buzzer_hz_frame, text="Buzzer Hz: ", bg="white", font=("Arial", 18))
    buzzer_hz_label.pack(side="left")
    buzzer_hz_var = tk.StringVar()
    buzzer_hz_value = tk.Label(buzzer_hz_frame, textvariable=buzzer_hz_var, bg="white", font=("Arial", 18))
    buzzer_hz_value.pack(side="left")   

    # Haptic Intensity
    haptic_frame = tk.Frame(display_values_frame, bg="white")
    haptic_frame.pack(pady=10)
    haptic_icon_label = tk.Label(haptic_frame, text="📳", bg="white", font=("Arial", 24))
    haptic_icon_label.pack(side="left", padx=(0, 10))
    haptic_intensity_label = tk.Label(haptic_frame, text="Haptic Intensity: ", bg="white", font=("Arial", 18))
    haptic_intensity_label.pack(side="left")
    haptic_intensity_var = tk.StringVar()
    haptic_intensity_value = tk.Label(haptic_frame, textvariable=haptic_intensity_var, bg="white", font=("Arial", 18))
    haptic_intensity_value.pack(side="left")

    # Light On/Off
    light_on_off_frame = tk.Frame(display_values_frame, bg="white")
    light_on_off_frame.pack(pady=10)
    light_on_off_icon_label = tk.Label(light_on_off_frame, text="💡", bg="white", font=("Arial", 24))
    light_on_off_icon_label.pack(side="left", padx=(0, 10))
    light_on_off_label = tk.Label(light_on_off_frame, text="Light On/Off: ", bg="white", font=("Arial", 18))
    light_on_off_label.pack(side="left")
    light_on_off_var = tk.StringVar()  # Set light to "On"
    light_on_off_value = tk.Label(light_on_off_frame, textvariable=light_on_off_var, bg="white", font=("Arial", 18))
    light_on_off_value.pack(side="left")

    # Create a "Go Back" button in display frame
    go_back_button_display = tk.Button(display_frame, text="Go Back", command=go_back, bg="black", fg="white", width=20, font=("Arial", 14))  
    go_back_button_display.pack(pady=20)  

    # Pack the display frame
    display_frame.pack(expand=True, fill="both")

    # Profile frame
    profile_frame = tk.Frame(root, bg="white")
    profile_label = tk.Label(profile_frame, text="Profile Screen", bg="white", font=("Arial", 20))
    profile_label.pack(pady=10)

    # Profile selection
    profile_var = tk.StringVar()
    profile_var.set("Profile 2")  # Default profile
    tk.Label(profile_frame, text="Select Profile:").pack()
    tk.OptionMenu(profile_frame, profile_var, *profiles.keys(), command=lambda _: display_profile_info()).pack()

    # Profile details
    tk.Label(profile_frame, text="Name:").pack()
    entry_name_profile = tk.Entry(profile_frame)  # Entry widget for displaying profile name
    entry_name_profile.pack()

    # Create settings frame
    settings_frame = tk.Frame(root, bg="white")
    settings_label = tk.Label(settings_frame, text="Settings Screen", bg="white", font=("Arial", 20))
    settings_label.pack(pady=10)

    # Settings frames
    button_settings_frame = tk.Frame(root, bg="white")
    battery_settings_frame = tk.Frame(root, bg="white")
    light_settings_frame = tk.Frame(root, bg="white")
    properties_settings_frame = tk.Frame(root, bg="white")

    settings_frames = [button_settings_frame, battery_settings_frame, light_settings_frame, properties_settings_frame]

    # Create settings subframes
    button_settings_frame = tk.Frame(root, bg="white")
    battery_settings_frame = tk.Frame(root, bg="white")
    light_settings_frame = tk.Frame(root, bg="white")
    properties_settings_frame = tk.Frame(root, bg="white")

    settings_frames = [button_settings_frame, battery_settings_frame, light_settings_frame, properties_settings_frame]

    # Create "Go Back" buttons once for each settings subframe
    go_back_button_button_settings = tk.Button(button_settings_frame, text="Go Back", command=go_back_to_settings, bg="black", fg="white", width=20, height=2, font=("Arial", 14))
    go_back_button_button_settings.pack(pady=20)

    go_back_button_battery_settings = tk.Button(battery_settings_frame, text="Go Back", command=go_back_to_settings, bg="black", fg="white", width=20, height=2, font=("Arial", 14))
    go_back_button_battery_settings.pack(pady=20)

    go_back_button_light_settings = tk.Button(light_settings_frame, text="Go Back", command=go_back_to_settings, bg="black", fg="white", width=20, height=2, font=("Arial", 14))
    go_back_button_light_settings.pack(pady=20)

    go_back_button_properties_settings = tk.Button(properties_settings_frame, text="Go Back", command=go_back_to_settings, bg="black", fg="white", width=20, height=2, font=("Arial", 14))
    go_back_button_properties_settings.pack(pady=20)

    # Create settings buttons
    settings_buttons = []
    for part in ["Button", "Battery", "Light", "Properties"]:
        button = tk.Button(settings_frame, text=part, command=lambda part=part: on_settings_button_click(part), bg="black", fg="white", width=50, height=5)
        settings_buttons.append(button)

    # Button settings
    button_categories = ["Change settings", "Battery status indication", "Toggle light"]
    option_buttons = []

    # Press duration selections
    duration_labels = ["Pressed for > 1.5 seconds", "Pressed for > 0.5 seconds", "Pressed for < 0.5 seconds"]
    duration_vars = [tk.StringVar(value=button_categories[0]) for _ in range(3)]

    for label_text, var in zip(duration_labels, duration_vars):
        label = tk.Label(button_settings_frame, text=label_text, bg="white")
        label.pack()
        menu = tk.OptionMenu(button_settings_frame, var, *button_categories, command=lambda option, label_text=label_text: option_selected("Button", label_text, option))
        menu.pack()


    # Battery settings
    battery_categories = ["100-75%", "75-50%", "50-25%", "25-1%"] 
    option_battery = []

    # Battery selections
    battery_life_label = ["1 beep-vibration", "2 beeps-vibrations", "3 beeps-vibrations", "4 beeps-vibrations"]
    battery_life_vars = [tk.StringVar(value=battery_categories[0]) for _ in range(4)]

    for label_text, var in zip(battery_life_label, battery_life_vars):
        label = tk.Label(battery_settings_frame, text=label_text, bg="white")
        label.pack()
        menu = tk.OptionMenu(battery_settings_frame, var, *battery_categories, command=lambda option, label_text=label_text: option_selected("Battery", label_text, option))
        menu.pack()

    # Light settings
    light_categories = ["On", "Off"] 
    option_light = []

    # Light selections
    light_label = ["1 beep-vibration", "2 beeps-vibrations"]
    light_vars = [tk.StringVar(value=light_categories[0]) for _ in range(2)]

    for label_text, var in zip(light_label, light_vars):
        label = tk.Label(light_settings_frame, text=label_text, bg="white")
        label.pack()
        menu = tk.OptionMenu(light_settings_frame, var, *light_categories, command=lambda option, label_text=label_text: option_selected("Light", label_text, option))
        menu.pack()

    light_intensity_options = ["Light", "Medium", "High"]
    light_intensity_vars = [tk.StringVar(value=light_intensity_options[0])]
    light_intensity_label = tk.Label(light_settings_frame, text="Light Intensity: ", bg="white")
    light_intensity_label.pack()
    light_intensity_menu = tk.OptionMenu(light_settings_frame, light_intensity_vars[0], *light_intensity_options, command=lambda option, label_text=label_text: option_selected("Light", label_text, option))
    light_intensity_menu.pack()

    light_on_off_options = ["On", "Off"]
    light_on_off_vars = tk.StringVar(value="On")  # Set light to "On"
    light_on_off_label = tk.Label(light_settings_frame, text="Light On/Off: ", bg="white")
    light_on_off_label.pack()
    light_on_off_option_menu = tk.OptionMenu(light_settings_frame, light_on_off_vars, *light_on_off_options, command=lambda option, label_text=label_text: option_selected("Light", label_text, option))
    light_on_off_option_menu.pack()

    # Properties settings
    properties_categories = ["10%", "25%", "50%", "75%", "100%"]
    option_properties = []

    # Properties selections
    properties_label = ["Haptic intensity", "Buzzer intensity"]
    properties_vars = [tk.StringVar(value=properties_categories[0]) for _ in range(2)]

    for label_text, var in zip(properties_label, properties_vars):
        label = tk.Label(properties_settings_frame, text=label_text, bg="white")
        label.pack()
        menu = tk.OptionMenu(properties_settings_frame, var, *properties_categories, command=lambda option, label_text=label_text: option_selected("Properties", label_text, option))
        menu.pack()

    buzzer_frequency_options = ["100 Hz", "250 Hz", "500 Hz", "750 Hz", "1000 Hz"]
    buzzer_frequency_var = tk.StringVar() 
    buzzer_frequency_label = tk.Label(properties_settings_frame, text="Buzzer frequency: ", bg="white")
    buzzer_frequency_label.pack()
    buzzer_frequency_option_menu = tk.OptionMenu(properties_settings_frame, buzzer_frequency_var, *buzzer_frequency_options, command=lambda option, label_text=label_text: option_selected("Properties", "Buzzer frequency", option))
    buzzer_frequency_option_menu.pack()

    # Create a "Go Back" button in profile frame
    go_back_button_profile = tk.Button(profile_frame, text="Go Back", command=go_back, bg="black", fg="white", width=20, height=2, font=("Arial", 14))  
    go_back_button_profile.pack(pady=20)  

    # Create a "Go Back" button in settings frame
    go_back_button_settings = tk.Button(settings_frame, text="Go Back", command=go_back, bg="black", fg="white", width=20, height=2, font=("Arial", 14))  
    go_back_button_settings.pack(pady=20)  
     

    # Create three bigger buttons with black background in main frame
    button2 = tk.Button(main_frame, text="Profile", command=lambda: on_button_click(2), bg="black", fg="white", width=50, height=5, font=("Arial", 18))  
    button2.pack(pady=5)

    button1 = tk.Button(main_frame, text="Display", command=lambda: on_button_click(1), bg="black", fg="white", width=50, height=5, font=("Arial", 18))  
    button1.pack(pady=5)

    button3 = tk.Button(main_frame, text="Settings", command=lambda: on_button_click(3), bg="black", fg="white", width=50, height=5, font=("Arial", 18))  
    button3.pack(pady=5)

    # Create a "Close" button in toolbar frame
    close_button = tk.Button(toolbar_frame, text="Close", command=close_program, bg="black", fg="white")
    close_button.pack(side="right", padx=10, pady=5)

    # Pack the button frame
    language_button.pack(side="bottom", fill="x", pady=50)

    # Show the start screen initially
    show_start_screen()

    # Run the GUI
    root.mainloop()
    
def serialCom():
    def read_serial(ser):
        while not exit_event.is_set():
            if ser.in_waiting > 0:
                data = ser.readline().decode().strip()
                print("Received:", data)
                global TempString
                TempString = data
                print(TempString)
                UpdateStatusValues(TempString)


    def write_serial(ser):
        while not exit_event.is_set():
            message = input("Enter message to send (or 'exit' to quit): ")
            if message.lower() == 'exit':
                exit_event.set()
                break
            ser.write(message.encode())
            # global batteryStatusVar
            # global lightIntensityVar
            # global buzzerIntensityVar
            # global buzzerHzVar
            # global hapticIntensityVar
            # global lightOnOffVar

            # batteryStatusVar = "1"
            # lightIntensityVar = "1"
            # buzzerIntensityVar = "1"
            # buzzerHzVar = "1"
            # hapticIntensityVar = "1"
            # lightOnOffVar = "1"

    def UpdateStatusValues(TempString):
    # tempstring splitten
        split_strings = [s for s in TempString.split('$') if s]

        global batteryStatusVar
        global lightIntensityVar
        global buzzerIntensityVar
        global buzzerHzVar
        global hapticIntensityVar
        global lightOnOffVar

        if((split_strings[0] == "display") and (7 == len(split_strings))):
            batteryStatusVar = split_strings[1]
            lightIntensityVar = split_strings[2]
            buzzerIntensityVar = split_strings[3]
            buzzerHzVar = split_strings[4]
            hapticIntensityVar = split_strings[5]
            lightOnOffVar = split_strings[6]



    
    # Start a thread to read serial data
    exit_event = threading.Event()
    serial_thread = threading.Thread(target=read_serial, args=(arduino,))
    serial_thread.start()

    # Start a thread to write serial data
    write_thread = threading.Thread(target=write_serial, args=(arduino,))
    write_thread.start()

    # Wait for threads to finish
    write_thread.join()
    serial_thread.join()

    # Close the serial connection
    arduino.close()

GUI_Thread = threading.Thread(target = rootMainLoop)
GUI_Thread.start()

Com_Thread = threading.Thread(target = serialCom)
Com_Thread.start()

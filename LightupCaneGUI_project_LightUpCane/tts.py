import tkinter as tk
from tkinter import PhotoImage
import pyttsx3

# text to speach 
def speak_text(text): 
    engine = pyttsx3.init()
    engine.say(text)
    engine.runAndWait()

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
    battery_status_var.set(battery_life_vars[0].get())
    light_intensity_var.set(light_intensity_vars[0].get())
    buzzer_intensity_var.set(properties_vars[1].get())
    buzzer_hz_var.set(buzzer_frequency_var.get())
    haptic_intensity_var.set(properties_vars[0].get())
    light_on_off_var.set(light_on_off_var.get())

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

def read_text():
    # Initialize an empty string to store the text
    all_text = ""

    # Determine which frame is currently visible
    visible_frame = None
    if start_frame.winfo_ismapped():
        visible_frame = start_frame
    elif display_frame.winfo_ismapped():
        visible_frame = display_frame
    elif profile_frame.winfo_ismapped():
        visible_frame = profile_frame
    elif settings_frame.winfo_ismapped():
        visible_frame = settings_frame
    elif main_frame.winfo_ismapped():
        visible_frame = main_frame

    # Traverse through all the widgets in the visible frame and extract their text
    if visible_frame:
        for widget in visible_frame.winfo_children():
            if isinstance(widget, (tk.Label, tk.Button, tk.Entry)):
                all_text += widget.cget("text") + "\n"
            elif isinstance(widget, tk.Text):
                all_text += widget.get("1.0", tk.END) + "\n"
            elif isinstance(widget, tk.OptionMenu):
                all_text += widget.cget("text") + "\n"
            else:
                all_text += get_widget_text(widget) + "\n"

    # Read out the text
    speak_text(all_text)

def get_widget_text(widget):
    # Check if the widget is a label, button, or OptionMenu
    if isinstance(widget, (tk.Label, tk.Button)):
        return widget.cget("text")
    # Check if the widget is an entry
    elif isinstance(widget, tk.Entry):
        return widget.get()
    # Check if the widget is an OptionMenu
    elif isinstance(widget, tk.OptionMenu):
        # Extract the text from the associated variable
        return widget._variable.get()
    else:
        # Initialize an empty string to store the text
        text = ""
        # Recursively traverse the children of the widget
        for child in widget.winfo_children():
            text += get_widget_text(child) + "\n"
        return text

# Create the main window
root = tk.Tk()
root.title("LightUpCane")
root.configure(bg="white")  

# Set the window to full screen
root.attributes('-fullscreen', True)

# Create toolbar frame
toolbar_frame = tk.Frame(root, bg="black")  
toolbar_frame.pack(side="top", fill="x")

# Add project name label to a frame with black background
project_name_frame = tk.Frame(toolbar_frame, bg="black")
project_name_frame.pack(padx=10, pady=5)
project_name_label = tk.Label(project_name_frame, text="Light-up Cane", bg="black", fg="white", font=("Arial", 24))  
project_name_label.pack()

# Create start frame
start_frame = tk.Frame(root, bg="black")
start_label = tk.Label(start_frame, text="Pleaes connect your LightupCane!", bg="black", fg="light blue", font=("Arial", 15))
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
light_on_off_var = tk.StringVar(value="On")  # Set light to "On"
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
    menu = tk.OptionMenu(button_settings_frame, var, *button_categories)
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
    menu = tk.OptionMenu(battery_settings_frame, var, *battery_categories)
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
    menu = tk.OptionMenu(light_settings_frame, var, *light_categories)
    menu.pack()

light_intensity_options = ["Light", "Medium", "High"]
light_intensity_vars = [tk.StringVar(value=light_intensity_options[0])]
light_intensity_label = tk.Label(light_settings_frame, text="Light Intensity: ", bg="white")
light_intensity_label.pack()
light_intensity_menu = tk.OptionMenu(light_settings_frame, light_intensity_vars[0], *light_intensity_options)
light_intensity_menu.pack()

light_on_off_options = ["On", "Off"]
light_on_off_var = tk.StringVar(value="On")  # Set light to "On"
light_on_off_label = tk.Label(light_settings_frame, text="Light On/Off: ", bg="white")
light_on_off_label.pack()
light_on_off_option_menu = tk.OptionMenu(light_settings_frame, light_on_off_var, *light_on_off_options)
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
    menu = tk.OptionMenu(properties_settings_frame, var, *properties_categories)
    menu.pack()

buzzer_frequency_options = ["100 Hz", "250 Hz", "500 Hz", "750 Hz", "1000 Hz"]
buzzer_frequency_var = tk.StringVar(value="1000 Hz") 
buzzer_frequency_label = tk.Label(properties_settings_frame, text="Buzzer frequency: ", bg="white")
buzzer_frequency_label.pack()
buzzer_frequency_option_menu = tk.OptionMenu(properties_settings_frame, buzzer_frequency_var, *buzzer_frequency_options)
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

# Create text-to-speech button
tts_button = tk.Button(root, text="Read Text", command=read_text, bg="black", fg="white", font=("Arial", 14))
tts_button.pack(side="bottom", pady=20, fill="x")

# Create a "Close" button in toolbar frame
close_button = tk.Button(toolbar_frame, text="Close", command=close_program, bg="black", fg="white")
close_button.pack(side="right", padx=10, pady=5)

# Show the start screen initially
show_start_screen()

# Run the GUI
root.mainloop()

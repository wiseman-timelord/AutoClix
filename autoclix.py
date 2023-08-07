import keyboard
import pyautogui
import winsound
import time
import random
import threading
from tqdm import tqdm
import yaml
import os

CONFIG_FILE = 'config.yaml'

def read_config():
    config = {}
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as f:
            config = yaml.safe_load(f)
    return config

def write_config(config):
    with open(CONFIG_FILE, 'w') as f:
        yaml.dump(config, f)

def get_timer_range():
    config = read_config()
    prev_settings = config.get('timer_range', None)

    if prev_settings:
        prev_str = f" (Previous: {prev_settings[0]} to {prev_settings[1]})"
    else:
        prev_str = ""

    while True:
        try:
            user_input = input(f"Enter range in minutes (e.g., 1 4){prev_str}: ")
            if not user_input and prev_settings:
                return prev_settings
            else:
                timer_range = [int(num) for num in user_input.split()]
                if len(timer_range) == 2 and timer_range[0] < timer_range[1]:
                    config['timer_range'] = timer_range
                    write_config(config)
                    return timer_range
                else:
                    raise ValueError("Invalid input. Two numbers separated by space (e.g., 1 4).")
        except ValueError as e:
            print(str(e))

def auto_click(min_time, max_time):
    global active
    while True:
        if not active:
            break
        wait_time = random.randint(min_time * 60, max_time * 60)  # Random wait time in seconds
        for t in tqdm(range(wait_time, 0, -1), desc="Time left", ncols=60, ascii=True):
            if not active:
                break
            time.sleep(1)
        if active:
            pyautogui.click()

def toggle_auto_click():
    global active
    if active:
        active = False
        print("Auto-click deactivated.")
        winsound.PlaySound("*", winsound.SND_ALIAS)  # Play the default Windows sound
    else:
        active = True
        print("Auto-click activated.")
        min_time, max_time = get_timer_range()
        winsound.PlaySound("*", winsound.SND_ALIAS)  # Play the default Windows sound
        threading.Thread(target=auto_click, args=(min_time, max_time)).start()

active = False
keyboard.add_hotkey('ctrl+shift+f12', toggle_auto_click)

try:
    print("Press Ctrl + Shift + F12 to activate/deactivate.")
    keyboard.wait('esc')  # Wait until 'Esc' key is pressed to stop the script
except KeyboardInterrupt:
    pass
finally:
    active = False
    print("\nScript terminated.")

#!/usr/bin/env python3
import evdev
import subprocess
import time

def notify(message, color):
    subprocess.run([
        "notify-send",
        "-h", f"string:bgcolor:{color}",
        "-a", "Lock Keys",
        message
    ])

keyboard = None

# find a device with lock LEDs
for path in evdev.list_devices():
    dev = evdev.InputDevice(path)
    try:
        leds = dev.leds()
    except OSError:
        continue

    if evdev.ecodes.LED_CAPSL in leds or evdev.ecodes.LED_NUML in leds:
        keyboard = dev
        break

if not keyboard:
    notify("⚠️ No keyboard with lock LEDs found.", "#f38ba8")
    exit(1)

# watch for caps/num lock events
for event in keyboard.read_loop():
    if event.type == evdev.ecodes.EV_LED:
        if event.code == evdev.ecodes.LED_CAPSL:
            if event.value:
                notify("🔠 CAPS LOCK ON", "#f38ba8")
            else:
                notify("🔡 CAPS LOCK OFF", "#89b4fa")
        elif event.code == evdev.ecodes.LED_NUML:
            if event.value:
                notify("🔢 NUM LOCK ON", "#fab387")
            else:
                notify("🔣 NUM LOCK OFF", "#94e2d5")


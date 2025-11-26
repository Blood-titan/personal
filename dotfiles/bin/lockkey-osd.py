#!/usr/bin/env python3
import evdev
import subprocess
import sys

def notify(msg):
    # Send a desktop notification
    subprocess.run(["notify-send", "-a", "Lock Keys", msg])

keyboard = None

# Find a device that has Caps/Num lock LEDs
for path in evdev.list_devices():
    dev = evdev.InputDevice(path)
    try:
        leds = dev.leds()
    except OSError:
        # Permission or hotplug issue, skip this device
        continue

    if evdev.ecodes.LED_CAPSL in leds or evdev.ecodes.LED_NUML in leds:
        keyboard = dev
        break

if keyboard is None:
    print("No keyboard with lock LEDs found.")
    sys.exit(1)

# Listen for LED changes (Caps/Num lock)
for event in keyboard.read_loop():
    if event.type == evdev.ecodes.EV_LED:
        if event.code == evdev.ecodes.LED_CAPSL:
            notify("🔠 CAPS LOCK " + ("ON" if event.value else "OFF"))
        elif event.code == evdev.ecodes.LED_NUML:
            notify("🔢 NUM LOCK " + ("ON" if event.value else "OFF"))


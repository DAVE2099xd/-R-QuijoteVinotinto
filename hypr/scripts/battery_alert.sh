#!/bin/bash

THRESHOLD=20
NOTIFIED=0

while true; do
    # Obtiene el porcentaje y el estado de carga (Charging / Discharging)
    BATTERY_PERCENT=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)
    STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null)

    if [ -n "$BATTERY_PERCENT" ] && [ "$STATUS" = "Discharging" ]; then
        if [ "$BATTERY_PERCENT" -le "$THRESHOLD" ] && [ "$NOTIFIED" -eq 0 ]; then
            notify-send -u critical "Batería baja" "Queda un ${BATTERY_PERCENT}%. Conecta el cargador."
            mpv --no-video --volume=80 ~/Music/Zao.wav &
            NOTIFIED=1
        elif [ "$BATTERY_PERCENT" -gt "$THRESHOLD" ]; then
            NOTIFIED=0
        fi
    fi
    sleep 60
done

#!/bin/bash

# Fetch weather data from wttr.in
WEATHER_DATA=$(curl -s "https://wttr.in/Split?format=j1" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$WEATHER_DATA" ]; then
    # Prefer jq for reliable JSON parsing if available
    if command -v jq >/dev/null 2>&1; then
        TEMP=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].temp_C // empty')
        DESC=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].weatherDesc[0].value // empty')
    else
        # Fallback to grep/cut if jq not installed
        TEMP=$(echo "$WEATHER_DATA" | grep -o '"temp_C": "[^"]*"' | head -1 | cut -d'"' -f4)
        DESC=$(echo "$WEATHER_DATA" | grep -o '"weatherDesc": \[{"value": "[^"]*"' | head -1 | cut -d'"' -f4)
    fi

    # Ensure we have sane defaults
    [ -z "$TEMP" ] && TEMP="N/A"
    [ -z "$DESC" ] && DESC="Unknown"
    
    # Check for NAN or invalid temperature values
    if [[ "$TEMP" =~ ^[0-9]+$ ]] || [[ "$TEMP" =~ ^-[0-9]+$ ]]; then
        # Valid temperature (integer)
        :
    elif [[ "$TEMP" =~ ^[0-9]+\.[0-9]+$ ]] || [[ "$TEMP" =~ ^-[0-9]+\.[0-9]+$ ]]; then
        # Valid temperature (float)
        :
    elif [[ "$TEMP" == "N/A" ]]; then
        # Already set to N/A
        :
    else
        # Invalid temperature (likely NAN or other error), set to N/A
        TEMP="N/A"
    fi

    # Map weather descriptions to emoji (avoid thermometer icon to not clash with laptop temp)
    if [[ "$DESC" =~ [Cc]lear ]] || [[ "$DESC" =~ [Ss]unny ]]; then
        EMOJI="🌞"
    elif [[ "$DESC" =~ [Pp]artly ]] || [[ "$DESC" =~ [Ll]ight[[:space:]]*cloud ]]; then
        EMOJI="🌤️"
    elif [[ "$DESC" =~ [Oo]vercast ]] || [[ "$DESC" =~ [Cc]loud ]]; then
        EMOJI="⛅"
    elif [[ "$DESC" =~ [Rr]ain ]] || [[ "$DESC" =~ [Dd]rizzle ]] || [[ "$DESC" =~ [Ss]hower ]]; then
        EMOJI="🌧️"
    elif [[ "$DESC" =~ [Tt]hunder ]] || [[ "$DESC" =~ [Ss]torm ]]; then
        EMOJI="⛈️"
    elif [[ "$DESC" =~ [Ss]now ]] || [[ "$DESC" =~ [Ss]leet ]]; then
        EMOJI="❄️"
    elif [[ "$DESC" =~ [Ff]og ]] || [[ "$DESC" =~ [Mm]ist ]] || [[ "$DESC" =~ [Hh]aze ]] || [[ "$DESC" =~ [Ss]moke ]]; then
        EMOJI="🌫️"
    else
        EMOJI="🌦️"
    fi

    # Bold the full string for readability
    WEATHER="<b>${EMOJI} ${TEMP}°C</b>"
else
    WEATHER="<b>🌥️ N/A</b>"
fi

# Optional: include tooltip with description
echo "{\"text\": \"$WEATHER\", \"class\": \"weather\", \"tooltip\": \"$DESC\"}"

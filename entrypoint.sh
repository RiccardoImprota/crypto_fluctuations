#!/bin/bash
echo "Running first setup"
python3 -u /app/src/first-history-scraping.py
python3 -u /app/src/historicingestion.py
python3 -u /app/src/predictor.py

echo "Running the bot"
exec python3 src/servinglayer.py &
exec python3 src/apicurrentpercentages.py &
exec python3 src/notifier.py &
echo "End script"

while true; do
    currenttime=$(date +%H:%M)
    if [[ "$currenttime" == "00:02" ]]; then
        echo "Updating data"
        pkill -f servinglayer.py
        pkill -f apicurrentpercentages.py
        pkill -f notifier.py
        python3 /app/src/apihistoricprices.py
        python3 /app/src/historicingestion.py
        python3 /app/src/predictor.py
        python3 /app/src/bandaid.py
        python3 /app/src/bandaid2.py
        sleep 10
        exec python3 src/servinglayer.py &
        exec python3 src/apicurrentpercentages.py &
        exec python3 src/notifier.py &

    fi
    currentminute=$(date +%M)
    if [[ "$currentminute" == "15" || "$currentminute" == "30" || "$currentminute" == "45" || "$currentminute" == "00" ]];
    then
        echo "Restart for fault tolerance"
        pkill -f servinglayer.py
        pkill -f apicurrentpercentages.py
        pkill -f notifier.py
        sleep 3
        exec python3 src/servinglayer.py &
        exec python3 src/apicurrentpercentages.py &
        exec python3 src/notifier.py &
    fi
    sleep 55
done


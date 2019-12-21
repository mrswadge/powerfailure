# Power Failure Detection
Detect when electrical power failures occur and store them in a CSV file.

The project was created as our electrical consumer unit was tripping randomly. The script attempts to identify a pattern of when the trips are occurring so they can be graphed.

Install via crontab

    crontab -e 

Add the following

    * * * * * ~/powerfailure/powerfailure.sh
    
When the computer is turned off a record will be created in `~/powerfailure.csv`.

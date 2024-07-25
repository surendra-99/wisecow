import requests
import sys
import logging
from datetime import datetime

# Configuration
URL = "http://your-application-url"  # Replace with your application's URL
LOG_FILE = "/var/log/app_health_checker.log"  # Log file path

# Set up logging
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def check_application_status(url):
    try:
        response = requests.get(url, timeout=10)  # Timeout after 10 seconds
        status_code = response.status_code
        if response.ok:  # Status code in the range 200-299
            logging.info("Application is UP (Status code: %d)", status_code)
            print("Application is UP")
        else:
            logging.error("Application is DOWN (Status code: %d)", status_code)
            print("Application is DOWN")
    except requests.RequestException as e:
        logging.error("Application is DOWN (Error: %s)", str(e))
        print("Application is DOWN")

if __name__ == "__main__":
    check_application_status(URL)


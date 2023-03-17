"""
In this script, you need to replace /path/to/log/folder with the actual path to the
log folder you want to scan. The script first gets a list of files in the log folder
and filters out any non-log files. It then gets the latest log file by finding the
file with the latest creation time. The creation time of the latest log file is
compared to the current time to determine if it was generated within one day. If it
was, the script prints a message saying so. If it wasn't, the script prints a message
indicating that the latest log file was generated more than one day ago. If no log
files were found in the log folder, the script prints a message saying so.


"""

import os
import datetime
import re
import logging
from subprocess import call
from pathlib import Path

# prepare properties
separator = "="
properties = {}

# http://stackoverflow.com/questions/27945073/how-to-read-properties-file-in-python
properties_path = '/home/cliff/.secret/properties'
my_file = Path(properties_path)
if not my_file.is_file():
    properties_path = '/home/cliff/.secret/properties'

with open(properties_path) as f:
    for line in f:
        if separator in line:
            name, value = line.split(separator, 1)
            properties[name.strip()] = value.strip()
webhook_url = properties.get('webhook_url')


def notify_by_slack(date):
    message = "Found an earlier date: " + date
    param = "-X POST -H 'Content-type: application/json' --data \"{'text':'" + \
            message + "'}\" " + webhook_url
    call("curl " + param, shell=True)


Log_Format = "%(levelname)s %(asctime)s - %(message)s"
tmp_log_dir = '~/tmp/'
logging.basicConfig(
    filename=tmp_log_dir + datetime.now().strftime('check_log_%Y-%m-%d_%H-%M-%S.log'),
    # stream = sys.stdout,
    filemode="w",
    format=Log_Format,
    level=logging.INFO)
logger = logging.getLogger()

log_folder_paths = ['/home/cliff/log/get_appt',
                    '/home/cliff/mnt/windows_share/FreeFileSyncLog']

found_issue = False
issue_message_header = ''

try:
    for log_folder_path in log_folder_paths:

        issue_message_header = 'The latest log under: ' + log_folder_path + ' '

        # Get the list of files in the log folder
        files = os.listdir(log_folder_path)

        # Filter out any non-log/html files
        log_files = [file for file in files if
                     file.endswith('.log') or file.endswith('.html')]

        if log_files:
            # Get the latest log file
            latest_log_file = max(log_files, key=os.path.getctime)

            # Get the creation time of the latest log file
            file_path = os.path.join(log_folder_path, latest_log_file)
            creation_time = os.path.getctime(file_path)

            # Get the current time
            now = datetime.datetime.now().timestamp()

            # Check if the latest log file was created within one day
            if (now - creation_time) < 86400:
                logger.info('The latest log file was generated within one day.')
            else:
                logger.error('The latest log file was generated more than one day ago.')
                notify_by_slack(issue_message_header + 'is more than 1 day')

            with open(file_path, "r") as file:
                contents = file.read()

            if re.search("Completed successfully", contents):
                logger.info("The file contains 'Completed successfully'.")
            else:
                logger.error("The file does not contain 'Completed successfully'.")
                notify_by_slack(
                    issue_message_header + " does not contain 'Completed "
                                           "successfully'.")

        else:
            logger.error('No log files were found in the log folder.')
            notify_by_slack(
                issue_message_header + " : no log found ")

except Exception as e:
    found_issue = True
    logger.error("Errors: ", str(e))
    notify_by_slack("Failed to run check_log script withe error:" + str(e))



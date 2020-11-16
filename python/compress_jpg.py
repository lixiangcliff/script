# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
from datetime import datetime
import time
import shlex
import logging
import subprocess
import os
from os import path
from PIL import Image



# setup path
#ROOT_PATH = '/Users/cli/per/tmp/'
ROOT_PATH = '/srv/dev-disk-by-label-NAS/Important/'
SOURCE_DIR = ROOT_PATH + 'Cliff/iPhone_Camera_backup/'
DEST_DIR = ROOT_PATH + 'cloud_photo_frame/all_original_jpg/'
DEST_COMPRESS_DIR = ROOT_PATH + 'cloud_photo_frame/all_compressed_jpg/'
LOG_DIR = ROOT_PATH + 'cloud_photo_frame/logs/'

dateTimeObj = datetime.now()
timestampStr = dateTimeObj.strftime("%Y-%m-%d_%H-%M-%S")

# setup logging
# create logger with 'spam_application'
logger = logging.getLogger('process_jpg')
logger.setLevel(logging.DEBUG)
# create file handler which logs even debug messages
fh = logging.FileHandler(LOG_DIR + timestampStr + '.log')
fh.setLevel(logging.DEBUG)
# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
# create formatter and add it to the handlers
formatter = logging.Formatter('[%(asctime)s][%(name)s][%(levelname)s]: %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)
# add the handlers to the logger
logger.addHandler(fh)
logger.addHandler(ch)


"""
1. rsync cliff's iphone folder all jpg to 'all_original_jpgs'
2. scan all files under 'all_original_jpgs':
    if there is a same name under corresponding path under 'all_compressed_jpg'
    else compress it to the corresponding place
"""


def execute():
    logger.info("Step1. rsync all JPG/jpg to cloud folder")
    # rsync_cmd = "rsync -avz --include='*/' --include='*.'{JPG,jpg} --exclude='*' --omit-dir-times " + SOURCE_DIR + " " + DEST_DIR # mac

    rsync_cmd = "rsync -avz --include='*.JPG' --include='*/' --exclude='*' --omit-dir-times " + SOURCE_DIR + " " + DEST_DIR # debian
    logger.debug("rsync_cmd: " + rsync_cmd)
    # os.system(rsync_cmd)
    direct_output = subprocess.check_output(rsync_cmd, shell=True)
    log_subprocess_output(direct_output)

    logger.info("Step2. scan all files under '" + DEST_DIR + "' folder")
    processed_photo_cnt = 0
    error_files = []

    for header_path, subdirs, files in os.walk(DEST_DIR):
        for name in files:
            # not jpg or JPG
            if '.JPG' not in name and '.jpg' not in name:
                continue

            original_file_path = os.path.join(header_path, name)
            logger.debug("Processing " + original_file_path)

            # get relative_filename and check if it exist in DEST_DIR
            relative_file_path = original_file_path.replace(DEST_DIR, '')

            # already have this compressed before
            compressed_file_path = os.path.join(DEST_COMPRESS_DIR, relative_file_path)
            if path.isfile(compressed_file_path):
                logger.debug("It has been compressed. so skip it!")
                continue
            try:
                os.makedirs(os.path.dirname(compressed_file_path), exist_ok=True)
                image = Image.open(original_file_path)
                exif = image.info['exif']
                image.save(compressed_file_path, overwrite=True, optimize=True, quality=60, exif=exif)
                processed_photo_cnt += 1
                logger.debug("Copy and compress done!")
            except Exception as e:
                error_files.append(original_file_path)
                logger.debug("Exception happens when processing: " + original_file_path)

    logger.info("Processed " + str(processed_photo_cnt) + " photos")
    if error_files:
        logger.info("Errored photo count:" + str(len(error_files)) + " photos")
        logger.info("They are:\n" + str(error_files))
        
    logger.info("Remove log older than 30 days")
    for f in os.listdir(LOG_DIR):
        if os.stat(os.path.join(LOG_DIR, f)).st_mtime < time.time() - 30 * 86400:
            os.remove(os.path.join(LOG_DIR, f))


def run_shell_command(command_line):
    print(command_line)
    command_line_args = shlex.split(command_line)

    logging.info('Subprocess: "' + command_line + '"')
    print('####')
    print(command_line_args)

    try:
        command_line_process = subprocess.Popen(
            command_line_args,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )

        process_output, _ = command_line_process.communicate()

        # process_output is now a string, not a file,
        # you may want to do:
        # process_output = StringIO(process_output)
        # logger.info(process_output.decode(encoding='UTF-8'))
        log_subprocess_output(process_output)
    except (OSError, subprocess.CalledProcessError) as exception:
        logging.info('Exception occured: ' + str(exception))
        logging.info('Subprocess failed')
        return False
    else:
        # no exception was raised
        logging.info('Subprocess finished')

    return True


def log_subprocess_output(byte_output):
    logger.info('\n' + byte_output.decode(encoding='UTF-8'))


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    execute()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/

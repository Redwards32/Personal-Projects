from moviepy.editor import *
import os
from pytube import YouTube
from pytube.cli import on_progress
import pytube.request
import random
import time

pytube.request.default_range_size = 500000

def status(num1, num2, text):
    for c in text:
        r = random.uniform(num1, num2)
        time.sleep(r)
        print(c, end='', flush=True)


def completed(a, b):
    completed = '\nDownload Complete!\n'
    size = 'File Size ' + str(stream.filesize/1000000) + ' Mb\n'
    title = 'Title: ' + stream.title + '\n'

    text_list = [completed, size, title]

    for t in text_list:
        status(.05, .1, t)
        print('-' * 60)

url = input('\nEnter a youtube URL that you want to convert into an MP3!: ')
try:
    yt = YouTube(url, on_progress_callback=on_progress, on_complete_callback=completed)
    stream = yt.streams.filter(progressive=True, file_extension='mp4').get_highest_resolution()
    status(.05, .1, 'Download is starting...\n')
    stream.download()
    status(.05, .1, 'Converting to MP3...\n')
    mp4_file = stream.title + ".mp4"
    mp3_file = stream.title + ".mp3"
    videoClip = VideoFileClip(mp4_file)
    audioclip = videoClip.audio
    audioclip.write_audiofile(mp3_file)
    audioclip.close()
    videoClip.close()
    status(.05, .1, 'Now deleting the MP4...\n')
    os.remove(stream.title + ".mp4")
    status(.05, .1, 'Deletion Complete!\n')
except:
    print('Something went wrong! Try again!')

Project in Python


I'm a broke college student who didn't have enough money for Spotify and data (on my phone).
Didn't want to go through the hassle of going to a third party website (potentially giving away cookies/data) and converting an MP4 to an MP3,
so I decided to do it myself.


Time It Took
------------
2 Days. Started Janurary 2nd, 2023
Ended Janurary 4th, 2023




Video of Program Working
------------------------
https://www.youtube.com/watch?v=MzOUgr-8BTk


Thoughts of the proccess
------------------------
1. Wanted to use Python since we can directly use either Spotfiy/YouTube API.
2. Heard about PyTube, seemed easy to implement especially client side.
3. Unfortunately, when planning out my program, I realized PyTube doesn't directly download the videos (desired by user) via MP3.
4. Had to implement MoviePy to do the conversion.
5. Realized I was wasting memory due to still having the MP4, so I wanted to program a way to delete the file in the Python directory.
6. Used Os to edit Python directory.


Library Breakdown
-----------------
Pytube library for installing videos (picked by user via link).
Moviepy library for converting the MP4 to MP3.
importos for going into directory of Python interaction and deleting MP4 file.



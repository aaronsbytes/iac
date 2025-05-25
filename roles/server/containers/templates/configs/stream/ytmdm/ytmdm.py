import os
import json
import concurrent.futures
import re
import requests
import threading
import shutil
import time

class YTMDM:
    def __init__(self):
        # Working directory
        # The top level directory where this script will be
        self.__log("Setting working directory")
        self.workdir = "/app"

        # Library directory
        # This is where your downloads will go
        self.__log("Setting library")
        self.libdir = "/music"

        # Get config
        self.config = self.load_config()

        # Path to yt-dlp executable
        self.__log("Setting location for yt-dlp executable")
        self.yt_dlp_path = f"{self.workdir}/yt-dlp"

        # Download yt-dlp
        self.download_ytdlp()

        # Get artists
        self.artists = self.get_artists()

        # Download all artists
        self.download_all_artists()

        # Sleep
        sleep_time = 60 * 60 * 6 # 6 hours
        time.sleep(sleep_time)

        # Exit
        self.__log("Done!")
        exit(0)

    def __log(self, msg, error=False):
        # Set prefix
        prefix = "[+]"

        # Set error prefix
        if error:
            prefix = "[-]"

        # Define final log message
        log_message = f"{prefix} {msg}"

        # Print message
        print(log_message)

    def get_artists(self):
        self.__log("Getting artists from artists.json")
        with open(f"{self.workdir}/artists.json") as f:
            data = json.load(f)
            return data

    def load_config(self):
        self.__log("Getting settings from config.json")
        with open(f"{self.workdir}/config.json") as f:
            data = json.load(f)
            return data

    def download_ytdlp(self):
        # Download latest yt-dlp
        self.__log("Downloading latest yt-dlp executable")
        os.system(f"wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O {self.yt_dlp_path}")

        # Make it executable
        os.system(f"chmod +x {self.workdir}/yt-dlp")

    def download_artist(self, artist):
        # Anounce download
        self.__log(f"Downloading {artist['pretty_name']}")

        # Define artist information
        artist_pretty_name = artist["pretty_name"]
        artist_id = artist["id"]
        artist_path = artist["path"]

        # Define yt-dlp command
        # Make sure you know what you're doing before changing anything here.
        yt_dlp_command = f"""
        {self.yt_dlp_path} -x --audio-format mp3 \
    	-f bestaudio \
    	--embed-thumbnail \
    	--convert-thumbnails jpg \
        --ppa 'EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop="'"'"'if(gt(ih,iw),iw,ih)'"':'"'if(gt(iw,ih),ih,iw)'"'"'"' \
    	-o "{self.libdir}/{artist_pretty_name}/%(album)s/%(artist)s - %(track)s.%(ext)s" \
    	--embed-metadata \
    	--replace-in-metadata "artist" "^.*$" "{artist_pretty_name}"  \
    	--parse-metadata "%(release_date>%Y-%m-%d,upload_date>%Y-%m-%d)s:%(meta_publish_date)s" \
    	--download-archive "{self.libdir}/{artist_pretty_name}/archive.txt" \
    	--windows-filenames \
    	--no-overwrites \
    	--yes-playlist \
    	--concurrent-fragments {self.config["concurrent-fragments"]} \
    	--no-live \
    	"https://youtube.com/{artist_id}{artist_path}"
        """

        # Execute yt-dlp command
        os.system(yt_dlp_command)

    def download_all_artists(self):
        # Define already downloaded/downloading artists
        downloaded_artists = set()  # Use a set for faster lookups
        lock = threading.Lock()  # Create a lock for thread-safe access

        # Multithreaded download of artists
        with concurrent.futures.ThreadPoolExecutor(max_workers=self.config["max-workers"]) as executor:
            futures = {}

            # Go through all artists
            for artist in self.artists:
                # Check if artist is already downloaded/downloading
                with lock:  # Ensure thread-safe access to downloaded_artists
                    if artist['pretty_name'] not in downloaded_artists:
                        # Add artist to list of already downloaded/downloading artists
                        downloaded_artists.add(artist['pretty_name'])

                        # Submit the download task
                        futures[executor.submit(self.download_artist, artist)] = artist

            # Wait for current futures to be completed
            for future in concurrent.futures.as_completed(futures):
                artist = futures[future]
                try:
                    future.result()  # This will raise an exception if the download failed
                except Exception as e:
                    self.__log(f"Error downloading {artist['pretty_name']}: {e}")


# Create instance for ytmdm
ytmdm = YTMDM()
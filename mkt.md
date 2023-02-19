## mkt

A simple wrapper script for [mktorrent](https://github.com/pobrn/mktorrent), a command-line tool for creating BitTorrent metainfo files.

`mkt` allows you to easily create torrent files for different trackers using pre-defined environment variables.

### Installation

Make sure you have mktorrent installed. Then, copy or download the mkt script to your preferred location:

```
sudo curl https://raw.githubusercontent.com/HouseOfTheAlchemist/Scripts/master/mkt -o /usr/local/bin
```

Make it executable with the following command:

```
chmod +x /usr/local/bin/mkt
```

### Usage

To use the script, first set environment variables for each tracker you wish to use. These environment variables should be in the format `ANNOUNCE_TRACKER_NAME`, where `TRACKER_NAME` are the initials of a tracker.

For example:

```
export ANNOUNCE_PTP='http://please.passthepopcorn.me:2710/YOUR_PASSKEY/announce'
```

Once the environment variables are set, you can run the script with the name of the tracker, followed by one or more file paths:

```
mkt [tracker] [file 1] [file 2] ..
```

### Examples

Create torrents using the tracker ptp

```
mkt ptp The.Atrocity.Exhibition.1998.Bdrip.1080p.x264.mkv /home/Downloads/Nosferatu.1922.Bdrip.1080p.x264.mkv
```


The script will search for an environment variable named `ANNOUNCE_TRACKER_NAME` based on the tracker name provided. If the variable is found, the corresponding announce URL will be passed to mktorrent as the -a option. If the variable is not found, the script will exit with an error.

For each file provided as an argument, the script will determine an appropriate piece size based on the file's size, and then use mktorrent to create a torrent file. The torrent file will be placed in the same directory as the original file.

#### Setting Environment Variables in Bash

Environment variables can be set in Bash using the following syntax:  

```
export VAR_NAME=value  
```

This will set the environment variable `VAR_NAME` to the value value.  
  
To make the changes permanent, you can add the line to your shell profile file (e.g. .bashrc or .bash_profile).

### Contributions
Feel free to open a pull request if you have any improvements or fixes.

### License
This script is released under the MIT License.

Have fun creating torrents! 🚀

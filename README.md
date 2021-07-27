# DDNet in Docker optimized for Unraid

This Docker will download and install a simple DDNet Dedicated server with a default autoexec.cfg preconfigured (the only thing that need to be changed is the Server Name and the RCON Password in the autoexec.cfg).

DDNet is an actively maintained version of DDRace, a Teeworlds modification with a unique cooperative gameplay. Help each other play through custom maps with up to 64 players and much more...

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for Serverdata | /serverdata |
| SERVER_DIR | Folder for Teeworlds | /serverdata/serverfiles |
| GAME_CONFIG | dm.cfg, ctf.cfg, tdm.cfg,... located in the main directory | autoexec.cfg |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Port the server will be running on | 8303 |

## Run example
```
docker run --name Teeworlds -d \
	-p 8303:8303 -p 8303:8303/udp \
	--env 'GAME_CONFIG=autoexec.cfg' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /mnt/user/appdata/ddnet:/serverdata/serverfiles \
	ich777/ddnetserver:latest
```

***ATTENTION: Please don't delete the file named "installedv-..." in the main directory!***

Update Notice: Simply restart the container if a newer version of the game is available and the container will download and install it.

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/